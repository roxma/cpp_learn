
all:
	g++ -MM -o defines.txt  foo.cpp
	g++ foo.cpp -o a.out

clean:
	rm -f defines.txt a.out

#       -M  Instead of outputting the result of preprocessing, output a rule
#	   suitable for make describing the dependencies of the main source
#	   file.  The preprocessor outputs one make rule containing the object
#	   file name for that source file, a colon, and the names of all the
#	   included files, including those coming from -include or -imacros
#	   command line options.
#
#	   Unless specified explicitly (with -MT or -MQ), the object file name
#	   consists of the name of the source file with any suffix replaced
#	   with object file suffix and with any leading directory parts
#	   removed.  If there are many included files then the rule is split
#	   into several lines using \-newline.	The rule has no commands.
#
#	   This option does not suppress the preprocessor’s debug output, such
#	   as -dM.  To avoid mixing such debug output with the dependency
#	   rules you should explicitly specify the dependency output file with
#	   -MF, or use an environment variable like DEPENDENCIES_OUTPUT.
#	   Debug output will still be sent to the regular output stream as
#	   normal.
#
#	   Passing -M to the driver implies -E, and suppresses warnings with
#	   an implicit -w.
#
#       -MM Like -M but do not mention header files that are found in system
#	   header directories, nor header files that are included, directly or
#	   indirectly, from such a header.
#
#	   This implies that the choice of angle brackets or double quotes in
#	   an #include directive does not in itself determine whether that
#	   header will appear in -MM dependency output.	 This is a slight
#	   change in semantics from GCC versions 3.0 and earlier.
#
#       -MF file
#	   When used with -M or -MM, specifies a file to write the
#	   dependencies to.  If no -MF switch is given the preprocessor sends
#	   the rules to the same place it would have sent preprocessed output.
#
#	   When used with the driver options -MD or -MMD, -MF overrides the
#	   default dependency output file.
#
#       -MG In conjunction with an option such as -M requesting dependency
#	   generation, -MG assumes missing header files are generated files
#	   and adds them to the dependency list without raising an error.  The
#	   dependency filename is taken directly from the "#include" directive
#	   without prepending any path.	 -MG also suppresses preprocessed
#	   output, as a missing header file renders this useless.
#
#	   This feature is used in automatic updating of makefiles.
#
#       -MP This option instructs CPP to add a phony target for each dependency
#	   other than the main file, causing each to depend on nothing.	 These
#	   dummy rules work around errors make gives if you remove header
#	   files without updating the Makefile to match.
#
#	   This is typical output:
#
#		   test.o: test.c test.h
#
#		   test.h:
#
#       -MT target
#	   Change the target of the rule emitted by dependency generation.  By
#	   default CPP takes the name of the main input file, deletes any
#	   directory components and any file suffix such as .c, and appends
#	   the platform’s usual object suffix.	The result is the target.
#
#	   An -MT option will set the target to be exactly the string you
#	   specify.  If you want multiple targets, you can specify them as a
#	   single argument to -MT, or use multiple -MT options.
#
#	   For example, -MT ’$(objpfx)foo.o’ might give
#
#		   $(objpfx)foo.o: foo.c
