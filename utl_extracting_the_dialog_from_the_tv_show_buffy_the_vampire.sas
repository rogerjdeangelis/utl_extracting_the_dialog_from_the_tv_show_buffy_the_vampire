Extracting the dialog from the TV show Buffy the Vampire

see
https://goo.gl/E5pTXo
https://stackoverflow.com/questions/48101501/split-long-string-by-a-vector-of-words

SAS and Perl are very good languages to clean up messy text?
Not sure about Python, not that familiar with Python.

INPUT

   Buffy script at
   http://www.buffyworld.com/buffy/transcripts/127_tran.html

   We want to extract just the dialog abd ignore stage directions and commets

INPUT
=====

   http://www.buffyworld.com/buffy/transcripts/127_tran.html

   Sample text

    BUFFY
      You dated a troll?
    ANYA
      Well, he wasn't a troll then. You know, he was just a big dumb guy.
      Cut to:
      2     EXT.    SUNNYDALE STREET
        IN FRONT OF MAGIC BOX - DAY
        Anya and Willow are talking.
      WILLOW
      Where is everyone?
    ANYA
      At the new high school. Buffy's got some kind of job there, Spike's insane in
      the basement.
      Cut to:
      3      INT.    BASEMENT AT
        SUNNYDALE HIGH - DAY
        Spike acting crazy in the basement, holding his hands to his ears and screaming.
      Cut to:
      4      INT.    CAVE NEAR
        SUNNYDALE - NIGHT
        Buffy and Xander are talking to an injured Willow.
      BUFFY
      Willow?


 WORKING CODE
 ============

   R  convert the html to text

     url <- "http://www.buffyworld.com/buffy/transcripts/127_tran.html";
     url <- read_html(url);
     all <- url %>% html_text();
     write(all, file = "d:/txt/buffy.txt");

   OUTPUT OF R TO SAS (output is in the log - easy to direct to a file)

     infile "d:/txt/buffy.txt";
     input;
     if left(_infile_) in  ("BUFFY","WILLOW","ANYA","XANDER","OLAF","D'HOFFRYN") then do;
        _infile_=left(_infile_);
        putlog _infile_;
        do until (substr(_infile,1,1) ne ' ');
          input;
          if index(_infile_,'Fade to black')>0 or index(_infile_,'Cut to:')> 0 then delete;
          if anylower(_infile_)>0 then putlog _infile_;
          if left(_infile_) in  ("BUFFY","WILLOW","ANYA","XANDER","OLAF","D'HOFFRYN") then do;
             _infile_=left(_infile_);
             putlog _infile_;
          end;
        end;
        putlog _infile_;
     end;


 OUTPUT  (in the log)
 ======

     BUFFY
       You dated a troll?

     ANYA
       Well, he wasn't a troll then. You know, he was just a big dumb guy.

     WILLOW
       Where is everyone?

     ANYA
       At the new high school. Buffy's got some kind of job there, Spike's insane in
       the basement.

     BUFFY
       Willow?

     WILLOW
       There you are!

     BUFFY
       We're really glad that you're back.

     XANDER
       Did you turn this nice lady's ex into a giant worm-monster?

     ANYA
       (laughs) Yes.

     ....

*                _              _       _
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|

;

  http://www.buffyworld.com/buffy/transcripts/127_tran.html


*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;

%utl_submit_wps64('
libname sd1 sas7bdat "d:/sd1";
libname wrk sas7bdat "%sysfunc(pathname(work))";
proc r;
submit;
source("C:/Program Files/R/R-3.3.2/etc/Rprofile.site", echo=T);
library(haven);
have<-read_sas("d:/sd1/have.sas7bdat");
require(rvest);
require(dplyr);
url <- "http://www.buffyworld.com/buffy/transcripts/127_tran.html";
url <- read_html(url);
all <- url %>% html_text();
write(all, file = "d:/txt/buffy.txt");
endsubmit;
import  r=have data=want;
run;quit;
');


* output to the log;
data want;
 length dialog $16000;
 file "d:/txt/inter.txt";
 infile "d:/txt/buffy.txt";
 input;
 if left(_infile_) in  ("BUFFY","WILLOW","ANYA","XANDER","OLAF","D'HOFFRYN") then do;
  _infile_=left(_infile_);
  putlog _infile_;
  do until (substr(_infile,1,1) ne ' ');
    input;
    if index(_infile_,'Fade to black')>0 or index(_infile_,'Cut to:')> 0 then delete;
    if anylower(_infile_)>0 then putlog _infile_;
    if left(_infile_) in  ("BUFFY","WILLOW","ANYA","XANDER","OLAF","D'HOFFRYN") then do;
     _infile_=left(_infile_);
      putlog _infile_;
    end;
  end;
  putlog _infile_;
  end;
run;quit;


* output to a file;
data want;
 length dialog $16000;
 file "d:/txt/utl_extracting_the_dialog_from_the_tv_show_buffy_the_vampire.txt";
 infile "d:/txt/buffy.txt";
 input;
 if left(_infile_) in  ("BUFFY","WILLOW","ANYA","XANDER","OLAF","D'HOFFRYN") then do;
  _infile_=left(_infile_);
  put _infile_;
  do until (substr(_infile,1,1) ne ' ');
    input;
    if index(_infile_,'Fade to black')>0 or index(_infile_,'Cut to:')> 0 then delete;
    if anylower(_infile_)>0 then put _infile_;
    if left(_infile_) in  ("BUFFY","WILLOW","ANYA","XANDER","OLAF","D'HOFFRYN") then do;
     _infile_=left(_infile_);
      put _infile_;
    end;
  end;
  put _infile_;
  end;
run;quit;

