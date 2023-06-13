// _userController.arbyBanner.value.banners == null ? SizedBox():Container(
// height: 130,
// // color: Colors.red,
// decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
//
// ),
// // child:  StaggeredGridView.countBuilder(
// //   crossAxisCount: 4,
// //   itemCount: _userController.arbyBanner.value.banners!.length,
// //   itemBuilder: (BuildContext context, int index) => Card(
// //     child: Column(
// //       children: <Widget>[
// //         Image.network(ApiUrl.baseImageUrl+"storage/${_userController.arbyBanner.value.banners![index].image}"),
// //
// //       ],
// //     ),
// //   ),
// //   staggeredTileBuilder: (int index) => new StaggeredTile.fit(3),
// //   mainAxisSpacing: 4.0,
// //   crossAxisSpacing: 4.0,
// // )
// child: StaggeredGridView.countBuilder(
// crossAxisCount: 4,
// itemCount: _userController.arbyBanner.value.banners!.length,
// itemBuilder: (BuildContext context, int index) =>  Container(
// height: 150,
// padding: EdgeInsets.all(8),
// margin: EdgeInsets.all(3),
// decoration:BoxDecoration(
// color: Colors.grey.withOpacity(0.3),
// borderRadius: BorderRadius.circular(15)
// ),
// child: Image.network(ApiUrl.baseImageUrl+"storage/${_userController.arbyBanner.value.banners![index].image}",
// fit: BoxFit.contain,
// ),
//
// ),
// staggeredTileBuilder: (int index) =>
// new StaggeredTile.count(2, index.isEven ? 2 : 1.5),
// mainAxisSpacing: 6.0,
// crossAxisSpacing: 4.0,
// ),
// ),
//
// SizedBox(
// height: 13,
// ),