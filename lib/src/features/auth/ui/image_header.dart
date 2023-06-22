part of 'auth_screen.dart';

class ImageHeader extends StatelessWidget {
  const ImageHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: .4.sh,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Assets.images.hello.provider(),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          alignment: Alignment.topRight,
          margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Text(
            'v.0.0.1 alpha',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
