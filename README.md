# Rubyception

A realtime log viewer for Rails (released under the MIT license)

--------------------

This shows a normal log entry
![screenshot 1](https://s3.amazonaws.com/tye/rubyception1.png)

This entry has an exception. The backtrace file names are clickable and will open in MacVim. Soon support for TextMate & other editors will be added.
![screenshot 2](https://s3.amazonaws.com/tye/rubyception2.png)

## Features

* Real-time updating of the log file using Websocket
* Filenames in exceptions are shown as links which open in MacVim (support for TextMate and other editors to be added soon)

## Installation

Add to your gemfile:
```ruby
gem 'rubyception'
```
Run:
```
bundle install
```
Add to your routes:
```ruby
match 'rubyception' => 'rubyception/application#index'
```
Open your app and go to:<br>
`http://localhost:3000/rubyception`<br>
Your log entries will appear on the rubyception page in realtime. You
must be using a browser that supports Websockets.

## Hotkeys
`up` or `k` Move selection up<br>
`down` or `j` Move selection down<br>
`enter` Expand selected entry<br>
`G` Go to last entry<br>
`gg` Go to first entry<br>
`42gg` or `42G` Go to 42nd entry<br>