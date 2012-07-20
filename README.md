# Rubyception

This project rocks and uses MIT-LICENSE.

## Installation

Add to your gemfile:
```ruby
gem 'rubyception'
```
Add to your routes:
```ruby
match 'rubyception' => 'rubyception/application#index'
```
Open your app and go to:<br>
`http://localhost:3000/rubyception`<br>
Your log entries will appear on the rubyception page in realtime. You
must be using a browser that supports Websockets.

## Hotkeys:
`up` or `k` Move selection up<br>
`down` or `j` Move selection down<br>
`enter` Expand selected entry<br>
`G` Go to last enter<br>
`gg` Go to first enter<br>
`42gg` or `42G` Go to line 42<br>
