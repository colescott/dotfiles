{ ... }:

{
  enable = true;
  autoReload = true;
  maxItems = 500;

  urls = [
    { url = "https://xkcd.com/rss.xml"; tags = []; }
    { url = "https://news.ycombinator.com/rss"; tags = []; }
    { url = "http://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml"; tags = []; }
  ];
}
