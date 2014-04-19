
function score(position){
  
  var lengthBtneye = lineDistance(
                            convertArrayToObj(position[25]),
                            convertArrayToObj(position[30]));
  var rightEye = lineDistance(
                      convertArrayToObj(position[23]),
                      convertArrayToObj(position[25]));

  var leftEye = lineDistance(
                        convertArrayToObj(position[30]),
                        convertArrayToObj(position[28]));

  var noseLengthV = pointLineDistance(
                        convertArrayToObj(position[42]),
                        convertArrayToObj(position[43]),
                        convertArrayToObj(position[33]));

  var noseLengthW = lineDistance(convertArrayToObj(position[35]),
                               convertArrayToObj(position[39]));


  var lipLengthW = lineDistance(convertArrayToObj(position[44]),
                               convertArrayToObj(position[50]));

  var lipLengthV = lineDistance(convertArrayToObj(position[47]),
                               convertArrayToObj(position[53]));

  var faceWidth = lineDistance(convertArrayToObj(position[0]),
                               convertArrayToObj(position[14]));

  var noseToJaw = lineDistance(convertArrayToObj(position[62]),
                               convertArrayToObj(position[7]));

  var upLip = faceWidth = lineDistance(convertArrayToObj(position[47]),
                               convertArrayToObj(position[60]));

  var lowLip = faceWidth = lineDistance(convertArrayToObj(position[57]),
                               convertArrayToObj(position[53]));

  var bow =  lineDistance(convertArrayToObj(position[19]),
                               convertArrayToObj(position[22]));
                               
  var faceWidth =  lineDistance(convertArrayToObj(position[0]),
                               convertArrayToObj(position[14]));

  var faceHeight =   pointLineDistance(
                        convertArrayToObj(position[26]),
                        convertArrayToObj(position[31]),
                        convertArrayToObj(position[7]));                            
                              


  var ratioScore1 = Math.abs(lengthBtneye-rightEye)*15;
  var ratioScore2 = Math.abs((noseLengthV/noseLengthW)-0.64)*15;
  var ratioScore3 = Math.abs(0.8-(noseLengthV/noseToJaw))*15;
  var ratioScore4 = Math.abs(2-(lipLengthW/lipLengthV))*4;
  var ratioScore5 = Math.abs(1-(lowLip/upLip))*11;
  var ratioScore6 = Math.abs(1-(noseLengthW/rightEye))*15;
  var ratioScore7 = Math.abs(0.809-(faceHeight/faceWidth))*15;

  var ratioScore1b = Math.abs(lengthBtneye-leftEye)*15;
  var ratioScore6b = Math.abs(1-(noseLengthW/rightEye))*15;

  var diff = Math.abs((ratioScore1+ratioScore6) - (ratioScore1b+ratioScore6b))*10;

  var sum = (ratioScore1+ratioScore2+ratioScore3+ratioScore4+ratioScore5+ratioScore6+ratioScore7)+(ratioScore1b+ratioScore2+ratioScore3+ratioScore4+ratioScore5+ratioScore6b+ratioScore7)
  var avg = sum/2


  return avg;


};

//module.exports = score;



function lineDistance(point1, point2) {
    
    var xdif = point1.x - point2.x;
    var ydif = point1.y - point2.y;
    
    xdif = xdif * xdif;
    ydif = ydif * ydif;
    
    return Math.sqrt(xdif+ydif);
}

function convertArrayToObj(point1)
{ 
  var obj = {};
  obj.x = point1[0];
  obj.y = point1[1];
  return obj;
}



function pointLineDistance(linePoint1, linePoint2, point) {
    
    var xdif = linePoint2.x - linePoint1.x;
    var ydif = linePoint2.y - linePoint1.y;
    var lineLengthSquare = xdif*xdif + ydif*ydif;
    
    var u = ((point.x - linePoint1.x)*xdif + (point.y - linePoint1.y)*ydif)/lineLengthSquare;
    
    if( u >1){
        u=1; }
     
    else if(u<0){
        u=0;
           }
    
    var nx = linePoint1.x + u*xdif;
    var ny = linePoint1.y + u*ydif;
    
    var sx = nx - point.x;
    var sy = ny - point.y;
    
    return Math.sqrt(sx*sx + sy*sy);
        
}  

