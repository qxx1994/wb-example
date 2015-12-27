package com.baidu.ueditor.upload;

import com.baidu.ueditor.define.AppInfo;
import com.baidu.ueditor.define.BaseState;
import com.baidu.ueditor.define.FileType;
import com.baidu.ueditor.define.State;
import org.apache.commons.codec.binary.Base64;
import org.webbuilder.utils.common.MD5;
import org.webbuilder.web.core.utils.SpringMvcContextUtil;
import org.webbuilder.web.po.resource.Resources;
import org.webbuilder.web.service.resource.FileService;

import java.io.ByteArrayInputStream;
import java.util.Map;

public final class Base64Uploader {

    public static State save(String content, Map<String, Object> conf) {

        byte[] data = decode(content);

        long maxSize = ((Long) conf.get("maxSize")).longValue();

        if (!validSize(data, maxSize)) {
            return new BaseState(false, AppInfo.MAX_SIZE);
        }
        String savePath = (String) conf.get("savePath");
        String suffix = FileType.getSuffix("JPG");
        try {
            FileService fileService = SpringMvcContextUtil.getBean(FileService.class);
            Resources resources = fileService.saveFile(new ByteArrayInputStream(data), MD5.encode(String.valueOf(System.nanoTime()) + Math.random()) + suffix);
            State state = new BaseState(true);
            state.putInfo("size", 0);
            state.putInfo("title", "");
            state.putInfo("url",  resources.getU_id());
            state.putInfo("type", suffix);
            return state;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new BaseState(false, AppInfo.IO_ERROR);
    }

    private static byte[] decode(String content) {
        return Base64.decodeBase64(content);
    }

    private static boolean validSize(byte[] data, long length) {
        return data.length <= length;
    }

}