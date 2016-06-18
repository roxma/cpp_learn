
# 一些 linux 小工具和脚本化开发环境配置（未完待续...）


这里将会介绍我在学习 linux 过程中写的几个有用的小工具，以及这些工具的打包和在多个远程机器的分发的思路和方法。希望能对你的 linux 学习有所帮助，也欢迎请联系 roxma@qq.com 交流学习心得。

这里为了上下文连贯，先介绍工具和环境，然后再介绍如何将自己的环境做打包和分发的，但也许你对这些工具并不感兴趣，所以可以直接跳到 [【工具的配置和打包分发】](#工具的配置和打包分发) 这一节阅读。



# 工具的配置和打包分发

## 动机

- 在学习过程中会积累各种小工具，涉及 bash, python 等脚本语言，可以集成到 bashrc 里面，方便调用。
- 日常开发工作需要操作多个机器，希望能把工具直接打包到一个脚本文件，执行一下脚本就可以直接安装和使用工具。
- 有些开发机在同事之前使用共享账户，所以不希望自己的 bashrc 和 vimrc 以及其他 vim 插件干扰到其他人的使用。

## 普通工具的打包安装

参考 [merge_tools.sh](merge_tools.sh)。基本思路是，bash 函数类的工具可以直接塞进 bashrc 里面，而 python 脚本，可以通过 bash64 编解码，利用 `python -c` 选项把 python 脚本转化成一个 bash 函数。 hello.py 代码:

```
#!/usr/bin/env python2
# -*- coding: utf-8 -*-

print "hello world\n"
```

通过执行 merge_tools.sh 后，hello.py 被转化成下面的 bash 函数：

```
function hello(){
python  -c "`echo 'QlpoOTFBWSZTWWZmEPEAAAfbgAAQeBKQUAAEH+XfoCAAVFNJ6mTTExGAaTDVNMnqeSbUGhp6IBHg
+0TLyTQbJBiFDxxYtHFTmZ1VoTTe+iKGj1WTjCN3anAi716H8lCCdi7kinChIMzMIeI=' | base64_decode | bzcat`"  "$@"
}
```

## 编译安装 vim

编译自己的 vim，除了 vim 以外还有可能需要安装其他其他的软件，打包的代码参考脚本 [local_software/Makefile](local_software/Makefile)。在一些特殊的环境不一定能将 vim 安装到系统目录下，所以需要在 `./configure` 的时候使用 `--prefix` 选项： `cd vim-master && ./configure --prefix="$(PREFIX)" --with-features=huge  --enable-pythoninterp && make && make install`。

编译安装完成后，为了方便地调用自己的 vim，可以修改的 bashrc 脚本，每当自己 ssh 登陆的时候，就执行 `alias vim="$(dir}/bin/vim"`，完整 bashrc 脚本可以参考 [vim/init.sh](vim/init.sh)

## 打包自己的 vim 插件环境

参考 [vim/merge_tools.sh](vim/merge_tools.sh) 打包脚本，主要内容为把 [vim/plugins](vim/plugins) 目录下的内容使用 tar 命令打包，然后再使用 base64 编码成字符串。第一次执行 vim/init.sh 的时候，把内容 base64 解码，tar 解压出插件，最终把插件安装到目标机器上。

## 分发技巧

在一台跳板机写一个expect脚本，需要更新工具的时候，通过执行脚本，把工具发到多台机器。

## 使用技巧

如果使用跳板机，在跳板机上编写自动登陆登陆 expect 脚本，登陆机器后自动执行配置环境的命令。

如果是通过 secureCRT 或者 xshell 之类的终端直连目标机器，也可以设置登陆自动执行脚本，配置环境。

如果使用了 tmux，可以在 xshell 或者 secureCRT 的自动登陆脚本里面加上一段 `tmux a || tmux`，表示选择可用的 tmux session，如果没有，就创建一个新的 tmux session。

