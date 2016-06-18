#!/bin/sh

# set -x


name="roxma"



echo "1. Hello\nMy name is $name"

echo '2. Hello\nMy name is $name'

# Words of the form $'string' are treated as ANSI-C Quoting
echo $'3. Hello\nMy name is $name'



# For double quoting, the backslash retains its special meaning only when followed by one of the following characters: ‘$’, ‘`’, ‘"’, ‘\’, or newline.
echo "4. Hello My \$name is \"$name\" This is a backlash: \\"

# the "'" character, for example, cannot be escapes
echo "5. Hello My name is \'$name\'"

echo "6. Hello
Nice to meet you\
What's your name?"



#A non-quoted backslash ‘\’ is the Bash escape character. It preserves the literal value of the next character that follows, with the exception of newline. If a \newline pair appears, and the backslash itself is not quoted, the \newline is treated as a line continuation (that is, it is removed from the input stream and effectively ignored). 
msg=7.\ Hello\
My\ name\ is\ $name
echo "$msg"

# ill formed
echo "8. an ill formed example:"
msg=Hello world

echo '9. msg=hello cmd'
msg=hello bash -c 'echo $msg'

