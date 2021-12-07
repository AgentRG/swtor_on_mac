{\rtf1\ansi\ansicpg1252\cocoartf2513
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fmodern\fcharset0 Courier;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;}
{\*\expandedcolortbl;;\cssrgb\c0\c0\c0;}
\margl1440\margr1440\vieww10800\viewh8400\viewkind0
\deftab720
\pard\pardeftab720\partightenfactor0

\f0\fs24 \cf2 \expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Patch provided by Josh Dubois, CrossOver product manager, CodeWeavers.\
--- /dev/null	2013-12-07 10:15:02.000000000 -0600\
+++ include/distversion.h	2013-12-07 10:14:51.000000000 -0600\
@@ -0,0 +1,12 @@\
+/* ---------------------------------------------------------------\
+ *   distversion.c\
+ *\
+ * Copyright 2013, CodeWeavers, Inc.\
+ * \
+ * Information from DISTVERSION which needs to find \
+ * its way into the wine tree.\
+ * --------------------------------------------------------------- */\
+\
+#define WINDEBUG_WHAT_HAPPENED_MESSAGE "This can be caused by a problem in the program or a deficiency in Wine. You may want to check <a href=\\"http://www.codeweavers.com/compatibility/\\">http://www.codeweavers.com/compatibility/</a> for tips about running this application."\
+\
+#define WINDEBUG_USER_SUGGESTION_MESSAGE "If this problem is not present under Windows and has not been reported yet, you can save the detailed information to a file using the \\"Save As\\" button, then <a href=\\"http://www.codeweavers.com/support/tickets/enter/\\">file a bug report</a> and attach that file to the report."\
}