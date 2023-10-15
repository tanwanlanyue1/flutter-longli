import 'package:flutter/material.dart';

class RatingBars extends StatefulWidget {


  @override
  _RatingBarsState createState() => _RatingBarsState();
}

class _RatingBarsState extends State<RatingBars> {
  String ratingValue ;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 300,),
            Row(
              children: <Widget>[
                Expanded(child: Container(),),
                RatingBar(
                  value: 9,
                  size: 30,
                  padding: 5,
                  nomalImage: 'images/star_no.png',
                  selectImage: 'imgags/star.png',
                  selectAble: true,
                  onRatingUpdate: (value) {
                    ratingValue = value;
                    setState(() {

                    });
                  },
                  maxRating: 10,
                  count: 6,
                ),
                Expanded(child: Container(),)
              ],
            ),
            SizedBox(height: 10,),
            Text(value())
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  String value() {
    if(ratingValue == null) {
      return '评分：9 分';
    }else {
      return '评分：$ratingValue  分';
    }
  }
}

class RatingBar extends StatefulWidget {
  final int count;
  final double maxRating;
  final double value;
  final double size;
  final double padding;
  final String nomalImage;
  final String selectImage;
  final bool selectAble;
  final ValueChanged<String> onRatingUpdate;

  RatingBar({
    this.maxRating = 10.0,
    this.count = 5,
    this.value = 10.0,
    this.size = 20,
    this.nomalImage,
    this.selectImage,
    this.padding,
    this.selectAble = false,
    @required this.onRatingUpdate
  }) : assert(nomalImage != null),
        assert(selectImage != null);

  @override
  _RatingBarState createState() => _RatingBarState();
}

class _RatingBarState extends State<RatingBar> {

  double value ;

  @override
  Widget build(BuildContext context) {
    return Listener(

      child: buildRowRating(),
      onPointerDown: (PointerDownEvent event){
        double x = event.localPosition.dx;
        if (x < 0) x = 0;
        pointValue(x);
      },
      onPointerMove: (PointerMoveEvent event) {
        double x = event.localPosition.dx;
        if (x < 0) x = 0;
        pointValue(x);
      },
      onPointerUp: (_) {
      },
      behavior: HitTestBehavior.deferToChild,
    );
  }

  pointValue(double dx) {
    if(!widget.selectAble) {
      return;
    }
    if(dx >= widget.size * widget.count  + widget.padding * (widget.count - 1)) {
      value = widget.maxRating;
    }else {
      for(double i = 1; i < widget.count + 1;i ++) {
        if(dx > widget.size * i + widget.padding *(i -1) && dx < widget.size * i + widget.padding * i) {
          value = i * (widget.maxRating/widget.count);
          break;
        }else if(dx > widget.size * (i -1) + widget.padding*(i -1) && dx < widget.size * i+ widget.padding*i )  {
          value = (dx - widget.padding *(i -1))/(widget.size * widget.count ) *widget.maxRating;
          break;
        }
      }
    }
    setState(() {
      widget.onRatingUpdate(value.toStringAsFixed(1));
    });
  }

  int fullStars() {
    if(value != null) {
      return (value /(widget.maxRating/widget.count)).floor();
    }
    return 0;
  }

  double star() {
    if(value != null) {
      if(widget.count / fullStars() == widget.maxRating / value ) {
        return 0;
      }
      return (value % (widget.maxRating/widget.count))/(widget.maxRating/widget.count);
    }
    return 0;
  }

  List<Widget> buildRow() {
    int full = fullStars();
    List<Widget> children = [];
    for(int i = 0; i < full; i ++) {
      children.add(Image.asset(widget.selectImage,height: widget.size,width: widget.size,));
      if(i < widget.count - 1) {
        children.add(SizedBox(width: widget.padding,),);
      }
    }
    if(full < widget.count) {
      children.add(ClipRect(
        clipper: SMClipper(rating: star() * widget.size),
        child: Image.asset(widget.selectImage,height: widget.size,width: widget.size),
      ));
    }

    return children;
  }

  List<Widget> buildNomalRow() {
    List<Widget> children = [];
    for(int i = 0; i < widget.count; i ++) {
      children.add(Image.asset(widget.nomalImage,height: widget.size,width: widget.size,));
      if(i < widget.count - 1) {
        children.add(SizedBox(width: widget.padding,));
      }
    }
    return children;
  }

  Widget buildRowRating() {
    return Container(
      child: Stack(
        children: <Widget>[
          Row(
            children: buildNomalRow(),
          ),
          Row(
            children: buildRow(),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    value = widget.value;
  }
}

class SMClipper extends CustomClipper<Rect>{
  final double rating;
  SMClipper({
    this.rating
  }): assert(rating != null);
  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0.0, 0.0, rating , size.height);
  }

  @override
  bool shouldReclip(SMClipper oldClipper) {
    return rating != oldClipper.rating;
  }
}