import 'package:flutter/cupertino.dart';

class BackgroundWaveClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {

    var path = Path();
    final p0 = size.height ;
    // path.lineTo(0.0, size.height);
    //path.lineTo(size.width, size.height- 80);
    //path.lineTo(size.width, 0);
    //path.close();
    path.lineTo(0.0, p0);
    final cp_x=size.width;
    final cp_y=size.height;
    final ep_x=size.width;
    final ep_y=size.height;
    /*final controlPoint = Offset(size.width * 0.6, size.height 0.5);
    final endPoint = Offset(size.width, size.height / 2);
    */
    path.quadraticBezierTo(cp_x, cp_y, ep_x, ep_y);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    oldClipper != this;
    return true;
  }
}
class BackgroundWaveClipper1 extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {

    var path = Path();
    final p0 = size.height ;
    // path.lineTo(0.0, size.height);
    //path.lineTo(size.width, size.height- 80);
    //path.lineTo(size.width, 0);
    //path.close();
    path.lineTo(0.0, p0*0.57);
    final cp_x=size.width;
    final cp_y=size.height*0.57;
    final ep_x=size.width;
    final ep_y=size.height*0.3;
    /*final controlPoint = Offset(size.width * 0.6, size.height 0.5);
    final endPoint = Offset(size.width, size.height / 2);
    */
    path.quadraticBezierTo(cp_x, cp_y, ep_x, ep_y);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    oldClipper != this;
    return true;
  }
}
class outlinewaveclip extends CustomClipper<Path>{
  @override
  @override
  Path getClip(Size size) {
    var path = Path();
    final p0 = size.height ;
    path.moveTo(size.width* 0.83, 0);
    path.lineTo(size.width*0.58,size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width,0);
    path.close();
    /*final controlPoint = Offset(size.width * 0.6, size.height 0.5);
    final endPoint = Offset(size.width, size.height / 2);
    */
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    oldClipper != this;
    return true;
  }
}