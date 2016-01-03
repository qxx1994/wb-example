

List areaList = [{name:"重庆",id:1},{name:"北京",id:3},{name:"上海",id:2}...........];
List dataList =[{id:3,number:20},{id:1,number:10},{id:2,number:5}.....];

Map tmp = {};
for(Area area: areaList){
    tmp.put(area.id,area);
}

for(Map data: dataList){
    data.name = tmp.get(data.id).name;
}
println(dataList);
//  dataList=[{name:"重庆",id:1,number:10},{name:"北京",id:3,number:20},{name:"上海",id:2,number:5}....];