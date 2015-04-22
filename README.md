# Max Fun Con Listener
  
## About

This small Ruby app checks the [Max Fun Con](http://www.maxfuncon.com/) website every two minutes and sees if there is a new `H2` tag in the `#blog` div. If a new tag has added, in other words, MaxFunCon posted a new post, it sends a tweet from [@a1erter](https://twitter.com/a1erter). It then updates the YAML file of blog post titles and exits the loop.

## Why?

The classes at Max Fun Con get booked fast and I don't want to get stuck in some class I'm not interested in or, even worse, not get into any classes at all.