#!/usr/bin/env perl

# Enable some flags
use strict;
use warnings FATAL => "all";
use feature qw(switch);

use YAML::XS;
no warnings "experimental";

# Check the arguments
my $argc = scalar @ARGV;
if ($argc < 1) {
    print "Missing document type\n";
    exit 1;
} elsif ($argc < 2) {
    print "Missing key\n";
    exit 1;
}

# Parse the arguments
my $document = $ARGV[0];
my $field    = $ARGV[1];

# Set some data structures we will need
my %fields = (
    "APKBUILD" => [
        "pkgname",  "subpackages",
        "pkgver",   "pkgrel",
        "arch",     "license",     "pkgdesc",
        "pkgusers", "pkggroups",   "depends", "depends_dev", "makedepends", "install",   "install_if", "options", "provides", "provider_priority", "replaces", "replacer_priority", "triggers",
        "url",      "giturl",      "source",  "md5sums",     "sha256sums",  "sha512sums"
    ],
    "PKGBUILD" => [
        "pkgname", "pkgver",
        "pkgdesc",
        "install", "changelog",
        "url"
    ],
    "RPMBUILD" => ["Name", "Version", "Summary", "License", "URL", "Source0", "BuildArch"],
    "CMAKE"    => [
        "PROJECT_NAME",                "PROJECT_VERSION",                "PROJECT_DESCRIPTION",       "PROJECT_HOMEPAGE_URL",
        "CPACK_GENERATOR",
        "CPACK_PACKAGE_NAME",          "CPACK_PACKAGE_VENDOR",           "CPACK_PACKAGE_CONTACT",     "CPACK_PACKAGE_DESCRIPTION_SUMMARY", "CPACK_PACKAGE_VERSION", "CPACK_PACKAGE_VERSION_MAJOR", "CPACK_PACKAGE_VERSION_MINOR",    "CPACK_PACKAGE_VERSION_PATCH", "CPACK_PACKAGE_VERSION_TWEAK", "CPACK_PACKAGE_INSTALL_DIRECTORY", "CPACK_PACKAGE_ICON",
        "CPACK_RESOURCE_FILE_LICENSE",
        "CPACK_SOURCE_GENERATOR",      "CPACK_SOURCE_PACKAGE_FILE_NAME", "CPACK_SOURCE_IGNORE_FILES",
        "CPACK_NSIS_MODIFY_PATH",      "CPACK_NSIS_DISPLAY_NAME",        "CPACK_NSIS_HELP_LINK",      "CPACK_NSIS_URL_INFO_ABOUT",         "CPACK_NSIS_MUI_ICON",   "CPACK_NSIS_MUI_UNIICON",      "CPACK_NSIS_INSTALLED_ICON_NAME",
        "CPACK_WIX_UPGRADE_GUID",      "CPACK_WIX_PRODUCT_ICON"
    ],
    "APPVEYOR" => ["version"],
    "DOCKER"   => [
        "AUTHOR_USER",      "AUTHOR_NAME",          "AUTHOR_NAME_ASCII", "AUTHOR_EMAIL",         "PROJECT_NAME",     "PROJECT_DESCRIPTION", "PROJECT_VERSION", "PROJECT_SHA512",
        "AUTHOR_CONTACT",   "AUTHOR_CONTACT_ASCII", "PROJECT_VENDOR",    "PROJECT_VENDOR_ASCII", "PROJECT_HOMEPAGE", "PROJECT_URL",         "PROJECT_VCS",     "PROJECT_SOURCE", "CMAKE_BUILD_TYPE",
        "LABEL_BUILD_DATE", "LABEL_NAME",           "LABEL_DESCRIPTION", "LABEL_USAGE",          "LABEL_URL",        "LABEL_VCS_URL",       "LABEL_VCS_REF",   "LABEL_VENDOR",   "LABEL_VERSION"
    ],
    "ABUILD"   => ["PACKAGER"]
);
my %numbers = (
    "APKBUILD" => [],
    "PKGBUILD" => ["pkgrel", "epoch"],
    "RPMBUILD" => [],
    "CMAKE"    => [],
    "APPVEYOR" => [],
    "DOCKER"   => [],
    "ABUILD"   => []
);
my %arrays = (
    "APKBUILD" => [],
    "PKGBUILD" => [
        "arch",    "license",     "groups",
        "depends", "makedepends", "optdepends", "checkdepends", "provides",   "conflicts",  "replaces",   "backup",    "options",
        "source",  "noextract",   "md5sums",    "sha1sums",     "sha224sums", "sha256sums", "sha384sums", "sha512sums"
    ],
    "RPMBUILD" => ["Requires", "BuildRequires" ],
    "CMAKE"    => [],
    "APPVEYOR" => [],
    "DOCKER"   => [],
    "ABUILD"   => []
);
my %complex = (
    "APKBUILD" => [],
    "PKGBUILD" => [],
    "RPMBUILD" => ["description", "prep", "build", "install", "check", "files", "changelog"],
    "CMAKE"    => [],
    "APPVEYOR" => [],
    "DOCKER"   => [],
    "ABUILD"   => []
);

# Check the arguments again
if (! exists $fields{$document}) {
    print "Unknown document type\n";
    exit 1;
}

# Parse the arguments again
my @fields  = @{$fields{$document}};
my @numbers = @{$numbers{$document}};
my @arrays  = @{$arrays{$document}};
my @complex = @{$complex{$document}};

# Check the arguments again
my $is_field   = grep { $_ eq $field } @fields;
my $is_number  = grep { $_ eq $field } @numbers;
my $is_array   = grep { $_ eq $field } @arrays;
my $is_complex = grep { $_ eq $field } @complex;

# Read the file from standard input to filer the lines
my @lines;
my $complex = -1;
my $cmake   = 0;
foreach my $line (<STDIN>) {
    chomp($line);
    given ($document) {
        when ("RPMBUILD") {
            if ($is_field || $is_array) {
                push @lines, $line if ($line =~ /^\Q$field\E: +.*$/);
            } elsif ($is_complex) {
                if ($complex > -1) {
                    my $match = $line =~ /^%([a-z]+)$/;
                    if ($match && grep { $_ eq $1 } @complex) {
                        foreach my $i (reverse $complex .. $#lines) {
                            if ($lines[$i] eq "") {
                                pop @lines;
                            } else {
                                last;
                            }
                        }
                        $complex = $1 eq $field ? $#lines + 1 : -1;
                    } else {
                        push @lines, $line
                    }
                } else {
                    $complex = $#lines + 1 if ($line =~ /^%\Q$field\E$/);
                }
            } else {
                push @lines, $line if ($line =~ /^%(global|define) +\Q$field\E +.+$/);
            }
        }
        when ("PKGBUILD") {
            if ($is_field) {
                push @lines, $line if ($line =~ /^\Q$field\E=".*"$/);
            } elsif ($is_number) {
                push @lines, $line if ($line =~ /^\Q$field\E=.*$/);
            } elsif ($is_array) {
                push @lines, $line if ($line =~ /^\Q$field\E\+?=\(".*"\)$/);
            } else {
                push @lines, $line if ($line =~ /^\Q$field\E=".*"$/);
            }
        }
        when ("APKBUILD") {
            push @lines, $line if ($line =~ /^\Q$field\E=".*"$/);
        }
        when ("CMAKE") {
            next if ($line =~ /^[\s\t ]*#/);
            if ($cmake == 0) {
                if ($line =~ /^\s*(?:set|SET)\s*\(\s*\Q$field\E\s+"((?:[^"\\]*|\\[^\s])*)"\s*\)\s*(?:#.*)?$/) {
                    push @lines, "set($field \"$1\")";
                } elsif ($line =~ /^\s*(?:set|SET)\s*\(\s*\Q$field\E\s+((?:[^\)\\]*|\\[^\s])*)\s*\)\s*(?:#.*)?$/) {
                    push @lines, "set($field \"$1\")";
                } elsif ($line =~ /^\s*(?:set|SET)\s*\(\s*\Q$field\E\s+"((?:[^"\\]*|\\[^\s])*)"\s*(?:#.*)?$/) {
                    push @lines, "set($field \"$1\")";
                } elsif ($line =~ /^\s*(?:set|SET)\s*\(\s*\Q$field\E\s+((?:[^\)\\]*|\\[^\s])*)\s*(?:#.*)?$/) {
                    push @lines, "set($field \"$1\")";
                } elsif ($line =~ /^\s*(?:set|SET)\s*\(\s*\Q$field\E\s*(?:#.*)?$/) {
                    push @lines, "set($field ";
                    $cmake = 1;
                } elsif ($line =~ /^\s*(?:set|SET)\s*\(\s*(?:#.*)?$/) {
                    push @lines, "set(";
                    $cmake = 2;
                }
            } elsif ($cmake == 1) {
                if ($line =~ /^\s*"((?:[^"\\]*|\\[^\s])*)"\s*\)\s*(?:#.*)?$/) {
                    $lines[$#lines] .= "\"$1\")";
                    $cmake = 0;
                } elsif ($line =~ /^\s*((?:[^\)\\]*|\\[^\s])*)\s*\)\s*(?:#.*)?$/) {
                    $lines[$#lines] .= "\"$1\")";
                    $cmake = 0;
                } elsif ($line =~ /^\s*"((?:[^"\\]*|\\[^\s])*)"\s*(?:#.*)?$/) {
                    $lines[$#lines] .= "\"$1\")";
                    $cmake = 0;
                } elsif ($line =~ /^\s*((?:[^\)\\]*|\\[^\s])*)\s*(?:#.*)?$/) {
                    $lines[$#lines] .= "\"$1\")";
                    $cmake = 0;
                }
            } elsif ($cmake == 2) {
                if ($line =~ /^\s*([a-zA-Z0-9_-]+)\s+"((?:[^"\\]*|\\[^\s])*)"\s*\)\s*(?:#.*)?$/) {
                    $lines[$#lines] .= "$1 \"$2\")";
                    $cmake = 0;
                    pop @lines if ($1 ne $field);
                } elsif ($line =~ /^\s*([a-zA-Z0-9_-]+)\s+((?:[^\)\\]*|\\[^\s])*)\s*\)\s*(?:#.*)?$/) {
                    $lines[$#lines] .= "$1 \"$2\")";
                    $cmake = 0;
                    pop @lines if ($1 ne $field);
                } elsif ($line =~ /^\s*([a-zA-Z0-9_-]+)\s+"((?:[^"\\]*|\\[^\s])*)"\s*(?:#.*)?$/) {
                    $lines[$#lines] .= "$1 \"$2\")";
                    $cmake = 0;
                    pop @lines if ($1 ne $field);
                } elsif ($line =~ /^\s*([a-zA-Z0-9_-]+)\s+((?:[^\)\\]*|\\[^\s])*)\s*(?:#.*)?$/) {
                    $lines[$#lines] .= "$1 \"$2\")";
                    $cmake = 0;
                    pop @lines if ($1 ne $field);
                } elsif ($line =~ /^\s*([a-zA-Z0-9_-]+)\s*(?:#.*)?$/) {
                    $lines[$#lines] .= "$1 ";
                    $cmake = 1;
                    if ($1 ne $field) {
                        pop @lines;
                        $cmake = 0;
                    }
                }
            }
        }
        when ("APPVEYOR") {
            push @lines, $line;
        }
        when ("DOCKER") {
            if ($is_field) {
                push @lines, $line if ($line =~ /^\s*ARG\s+\Q$field\E=".*"\s*(?:#.*)?$/);
            }
        }
        when ("ABUILD") {
            push @lines, $line if ($line =~ /^\Q$field\E=".*"$/);
        }
    }
}

my $skip = 0;
if (@lines > 0) {
    if ($is_field) {
        given ($document) {
            when ("RPMBUILD") { $lines[$#lines] =~ s/^\Q$field\E:\s+(.*)$/$1/;       }
            when ("PKGBUILD") { $lines[$#lines] =~ s/^\Q$field\E="(.*)"$/$1/;        }
            when ("APKBUILD") { $lines[$#lines] =~ s/^\Q$field\E="(.*)"$/$1/;        }
            when ("ABUILD")   { $lines[$#lines] =~ s/^\Q$field\E="(.*)"$/$1/;        }
            when ("CMAKE")    { $lines[$#lines] =~ s/^set\(\Q$field\E "(.*)"\)$/$1/; }
            when ("APPVEYOR") {
                $skip = 1;
                my $data = join "\n", @lines;
                my $yml = Load $data;
                print $yml->{$field};
            }
            when ("DOCKER") {
                $lines[$#lines] =~ s/^\s*ARG\s+\Q$field\E="(.*)"\s*(?:#.*)?$/$1/;
            }
        }
        print $lines[$#lines] if ($skip == 0);
    } elsif ($is_number) {
        given ($document) {
            when ("PKGBUILD") { $lines[$#lines] =~ s/^\Q$field\E=(.*)$/$1/; }
            when ("APKBUILD") { $lines[$#lines] =~ s/^\Q$field\E=(.*)$/$1/; }
        }
        print $lines[$#lines];
    } elsif ($is_array) {
        given ($document) {
            when ("RPMBUILD") {
                foreach (@lines) { $_ =~ s/^\Q$field\E: +(.*)$/$1/ }
            }
            when ("PKGBUILD") {
                foreach (@lines) { $_ =~ s/^\Q$field\E\+?=\((".*")\)$/$1/ }
                map {
                    s/"([^"]*)"/$1/g;
                    split " ", $_
                } @lines
            }
        }
        print join " ", @lines;
    } elsif ($is_complex) {
        print join "\n", @lines;
    } else {
        given ($document) {
            when ("RPMBUILD") { $lines[$#lines] =~ s/^%(global|define) +\Q$field\E +(.*)$/$2/; }
            when ("PKGBUILD") { $lines[$#lines] =~ s/^\Q$field\E="(.*)"$/$1/;                  }
            when ("APKBUILD") { $lines[$#lines] =~ s/^\Q$field\E="(.*)"$/$1/;                  }
            when ("CMAKE")    {
                $lines[$#lines] =~ s/^set\(\Q$field\E "(.*)"\)$/$1/;
                $lines[$#lines] =~ s/\\([\(\)"])/$1/g;
            }
        }
        print $lines[$#lines];
    }
    print "\n"
}
