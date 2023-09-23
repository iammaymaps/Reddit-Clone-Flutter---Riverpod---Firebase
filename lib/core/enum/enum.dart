enum ThemMode { light, dark }

enum UserKarma {
  comment(1),
  textpost(1),
  linkpost(3),
  imagePost(3),
  awardPost(5),
  deletePost(-1);

  final int karma;

  const UserKarma(this.karma);
}
