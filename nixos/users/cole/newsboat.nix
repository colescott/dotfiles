{ ... }:

{
  enable = true;
  autoReload = true;
  maxItems = 500;

  urls = [
    { url = "https://xkcd.com/rss.xml"; tags = []; }
    { url = "https://news.ycombinator.com/rss"; tags = []; }
    { url = "http://arxiv.org/rss/cs"; tags = []; }
    { url = "http://arxiv.org/rss/math.QA"; tags = []; }
    { url = "http://arxiv.org/rss/quant-ph"; tags = []; }
  ];
}
