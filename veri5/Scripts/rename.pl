#!/usr/bin/perl -w

use strict;

use Cwd qw(getcwd);
use Getopt::Long;       # get options
use File::Find;

my $curDir = getcwd;

my $dir= undef;
my $postfix = "sv";

my $oldpat = undef;
my $newpat = undef;
my $opt_h;
my $opt_help;
my $opt_no_rename;

my $opt_ok = &GetOptions(
                       "old=s"     => \$oldpat  
                      ,"new=s"     => \$newpat
                      ,"dir=s"     => \$dir
                      ,"postfix=s" => \$postfix
					  ,"no_rename" => \$opt_no_rename
                      ,"help"      => \$opt_help
                      ,"h"         => \$opt_h
                        );

&Print_help if $opt_help;
&Print_help if $opt_h;

if(not defined $oldpat) {
  print "Please use -old to pass old pattern\n";
  exit 1;
}

if(not defined $newpat) {
  print "Please use -new to pass new pattern\n";
  exit 1;
}

if(not defined $dir) {
  $dir = $curDir;
} else {
  chdir $dir;
}

print "pattern      : [old] $oldpat => [new] $newpat\n";
print "work dir     : $dir\n";
print "change files : *.$postfix\n";

my $oldpat_UC = uc($oldpat);
my $newpat_UC = uc($newpat);

$postfix = ".".$postfix;

#opendir(DH, $dir) || die "Can not open $dir: $!";
#close(DH);

#my @files=`find . | grep $postfix`;
my @subdir;
my $last_sub_dir = "";

sub getDirs {
  if($File::Find::dir ne $dir and $File::Find::dir ne $last_sub_dir){
    print "Find a sub dir : $File::Find::dir\n";
    push(@subdir, $File::Find::dir);
    $last_sub_dir = $File::Find::dir;
  }
}

find(\&getDirs, $dir);

if(not defined $opt_no_rename){
  foreach (@subdir) {
    chomp($_);
    my $old_dir = $_;
    my $new_dir = $_;
    if($old_dir =~ m/$oldpat/){
      $new_dir =~ s/$oldpat/$newpat/g;
      print "rename sub dir name from $old_dir to $new_dir\n";
      move($old_dir, $new_dir);
    }
  }
}

my @files;
sub getFiles {
  if ( $File::Find::name =~ /$postfix$/ ) {
    print "Find a file : $File::Find::name\n";
    push(@files, $File::Find::name);
  }
}

find(\&getFiles, $dir);

#print @files;

foreach (@files) {
  chomp($_);
  my $old_file = $_;
  my $new_file;
  if(not defined $opt_no_rename and $old_file =~ m/$oldpat/){
    my $file_name;
    my $file_path;
    $old_file =~ m/(.*)\/(.*)/;
    $file_path = $1;
    $file_name = $2;
    $file_name =~ s/$oldpat/$newpat/g;
    $new_file = $file_path."/".$file_name;
    print "rename $old_file to $new_file\n";
    rename($old_file, $new_file) || die "Cannot rename $old_file to $new_file!";
  }else{
    $new_file = $old_file;
  }
  print("perl -i -pe 's/$oldpat/$newpat/g' $new_file\n");
  print("perl -i -pe 's/$oldpat_UC/$newpat_UC/g' $new_file\n");
  
  system("perl -i -pe 's/$oldpat/$newpat/g' $new_file");
  system("perl -i -pe 's/$oldpat_UC/$newpat_UC/g' $new_file");
  unlink("$new_file.bak");
}

chdir $curDir;

exit(0);


#-----------------------------------------#
# Help information
#-----------------------------------------#
sub Print_help{
  my $help_string = <<HELP_INFO;

  This program is used to rename a certern pattern to an new parttern.
  1. It will update the content of the files which have a given postfix.
  2. It will change the files name if contain the old parttern.
  3. It will also update all upcase pattern.
  4. Only apply to the current directory.

  The followng options are supported
  ==================================
  -help
  -h            : This help

  -old          : The pattern want to change.
  -new          : The pattern want to see after change.
  -postfix      : only the files whose postfix are equal to -postfix options will be applied.

HELP_INFO
  print $help_string;

  exit 0;
}

