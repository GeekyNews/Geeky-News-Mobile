//url	The item's unique url.
//deleted	true if the item is deleted.
//type	The type of item. One of "job", "story", "comment", "poll", or "pollopt".
//by	The username of the item's author.
//time	Creation date of the item, in Unix Time.
//text	The comment, story or poll text. HTML.
//dead	true if the item is dead.
//parent	The comment's parent: either another comment or the relevant story.
//poll	The pollopt's associated poll.
//kurls	The urls of the item's comments, in ranked display order.
//url	The URL of the story.
//score	The story's score, or the votes for a pollopt.
//title	The title of the story, poll or job.
//parts	A list of related pollopts, in display order.
//descendants	In the case of stories or polls, the total comment count.

class HackerNewsItem {
  final String author;
  final String url;
  final String title;
  final String body;
  final String time;
  
  HackerNewsItem({this.author, this.url, this.title, this.body, this.time});

  factory HackerNewsItem.fromJson(Map<String, dynamic> json) {
    return HackerNewsItem(
      author: json['by'],
      url: json['url'],
      title: json['title'],
      body: json['body'],
//      time: json['time'],
    );
  }
}