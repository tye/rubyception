# Rubyception

This project rocks and uses MIT-LICENSE.

## Installation

Add to your gemfile:
    gem 'rubyception'
Add to your routes:
    match 'rubyception' => 'rubyception/application#index'
Open your app and go to
    http://localhost:3000/rubyception
Your log entries will appear on the rubyception page in realtime. You
must be using a browser that supports Websockets.

Hotkeys:
`up` or `k` Move selection up
`down` or `j` Move selection down
`enter` Expand selected entry
`G` Go to last enter
`gg` Go to first enter
`42gg` or `42G` Go to line 42
