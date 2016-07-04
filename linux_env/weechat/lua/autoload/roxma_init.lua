weechat.register("roxma_inittt", "roxma", "1.0", "GPL3", "roxma's init script", "", "")

freenode = weechat.config_string(weechat.config_get("irc.server.freenode.addresses"))

if (freenode == "")
then
    weechat.command("", "/server add freenode                  chat.freenode.net")
    weechat.command("", "/set irc.server.freenode.addresses    chat.freenode.net/7000")
    weechat.command("", "/set irc.server.freenode.ssl          on")
    weechat.command("", "/set irc.server.freenode.nicks        roxma")
    weechat.command("", "/set irc.server.freenode.autoconnect  on")

end

-- smart filter
weechat.command("", "/set irc.look.smart_filter on")
weechat.command("", "/filter add irc_smart * irc_smart_filter *")

-- status bar
weechat.command("", "/set weechat.bar.status.color_bg 8")
-- more simple status bar, the time item is distracting me, disable it
weechat.command("", "weechat.bar.status.items ' buffer_number+:+buffer_plugin+.+buffer_plugin+.+buffer_name'")

