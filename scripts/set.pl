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
} elsif ($argc < 3) {
    print "Missing value\n";
    exit 1;
}

# Parse the arguments
my $document = $ARGV[0];
my $field    = $ARGV[1];
my $value    = $ARGV[2];

# Set some data structures we will need
my %fields = (
    "APKBUILD" => [
        "pkgname",  "subpackages", "pkgver",
        "arch",     "license",     "pkgdesc",
        "pkgusers", "pkggroups",   "depends", "depends_dev", "makedepends", "install", "install_if", "options", "provides", "provider_priority", "replaces", "replacer_priority", "triggers",
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
    "APKBUILD" => ["pkgrel"],
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
    "RPMBUILD" => ["Requires", "BuildRequires"],
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
my @indexes;
my $complex = -1;
foreach my $line (<STDIN>) {
    chomp($line);
    push @lines, $line;
    given ($document) {
        when ("RPMBUILD") {
            if ($is_field || $is_array) {
                push @indexes, $#lines if ($line =~ /^\Q$field\E: +.*$/);
            } elsif ($is_complex) {
                if ($complex > -1) {
                    my $match = $line =~ /^%([a-z]+)$/;
                    if ($match && grep { $_ eq $1 } @complex) {
                        foreach my $i (reverse $complex .. $#indexes) {
                            if ($lines[$indexes[$i]] eq "") {
                                pop @indexes;
                            } else {
                                last;
                            }
                        }
                        $complex = $1 eq $field ? $#indexes + 1 : -1;
                    } else {
                        push @indexes, $#lines;
                    }
                } else {
                    $complex = $#indexes + 1 if ($line =~ /^%\Q$field\E$/);
                }
            } else {
                push @indexes, $#lines if ($line =~ /^%(global|define) +\Q$field\E +.+$/);
            }
        }
        when ("PKGBUILD") {
            if ($is_field) {
                push @indexes, $#lines if ($line =~ /^\Q$field\E=".*"$/);
            } elsif ($is_number) {
                push @indexes, $#lines if ($line =~ /^\Q$field\E=.*$/);
            } elsif ($is_array) {
                push @indexes, $#lines if ($line =~ /^\Q$field\E\+?=\(".*"\)$/);
            } else {
                push @indexes, $#lines if ($line =~ /^\Q$field\E=".*"$/);
            }
        }
        when ("APKBUILD") {
            push @indexes, $#lines if ($line =~ /^\Q$field\E=".*"$/);
        }
        when ("CMAKE") {
            next if ($line =~ /^[\s\t ]*#/);
            if ($complex == -1) {
                my @nested = ($#lines, $#lines, $#lines, $#lines);
                if ($line =~ /^\s*(?:set|SET)\s*\(\s*\Q$field\E\s+"(?:[^"\\]*|\\[^\s])*"\s*\)\s*(?:#.*)?$/) {
                    push @indexes, \@nested;
                    $complex = -1;
                } elsif ($line =~ /^\s*(?:set|SET)\s*\(\s*\Q$field\E\s+(?:[^\)\\]*|\\[^\s])*\s*\)\s*(?:#.*)?$/) {
                    push @indexes, \@nested;
                    $complex = -1;
                } elsif ($line =~ /^\s*(?:set|SET)\s*\(\s*\Q$field\E\s+"(?:[^"\\]*|\\[^\s])*"\s*(?:#.*)?$/) {
                    push @indexes, \@nested;
                    $complex = 0;
                } elsif ($line =~ /^\s*(?:set|SET)\s*\(\s*\Q$field\E\s+(?:[^\)\\]*|\\[^\s])*\s*(?:#.*)?$/) {
                    push @indexes, \@nested;
                    $complex = 0;
                } elsif ($line =~ /^\s*(?:set|SET)\s*\(\s*\Q$field\E\s*(?:#.*)?$/) {
                    push @indexes, \@nested;
                    $complex = 1;
                } elsif ($line =~ /^\s*(?:set|SET)\s*\(\s*(?:#.*)?$/) {
                    push @indexes, \@nested;
                    $complex = 2;
                }
            } elsif ($complex == 0) {
                if ($line =~ /^\s*\)\s*(?:#.*)?$/) {
                    $indexes[$#indexes][3] = $#lines;
                    $complex = -1;
                }
            } elsif ($complex == 1) {
                if ($line =~ /^\s*"(?:[^"\\]*|\\[^\s])*"\s*\)\s*(?:#.*)?$/) {
                    $indexes[$#indexes][2] = $#lines;
                    $indexes[$#indexes][3] = $#lines;
                    $complex = -1;
                } elsif ($line =~ /^\s*(?:[^\)\\]*|\\[^\s])*\s*\)\s*(?:#.*)?$/) {
                    $indexes[$#indexes][2] = $#lines;
                    $indexes[$#indexes][3] = $#lines;
                    $complex = -1;
                } elsif ($line =~ /^\s*"(?:[^"\\]*|\\[^\s])*"\s*(?:#.*)?$/) {
                    $indexes[$#indexes][2] = $#lines;
                    $complex = 0;
                } elsif ($line =~ /^\s*(?:[^\)\\]*|\\[^\s])*\s*(?:#.*)?$/) {
                    $indexes[$#indexes][2] = $#lines;
                    $complex = 0;
                }
            } elsif ($complex == 2) {
                if ($line =~ /^\s*([a-zA-Z0-9_-]+)\s+"(?:[^"\\]*|\\[^\s])*"\s*\)\s*(?:#.*)?$/) {
                    $indexes[$#indexes][1] = $#lines;
                    $indexes[$#indexes][2] = $#lines;
                    $indexes[$#indexes][3] = $#lines;
                    $complex = -1;
                    pop @indexes if ($1 ne $field);
                } elsif ($line =~ /^\s*([a-zA-Z0-9_-]+)\s+(?:[^\)\\]*|\\[^\s])*\s*\)\s*(?:#.*)?$/) {
                    $indexes[$#indexes][1] = $#lines;
                    $indexes[$#indexes][2] = $#lines;
                    $indexes[$#indexes][3] = $#lines;
                    $complex = -1;
                    pop @indexes if ($1 ne $field);
                } elsif ($line =~ /^\s*([a-zA-Z0-9_-]+)\s+"(?:[^"\\]*|\\[^\s])*"\s*(?:#.*)?$/) {
                    $indexes[$#indexes][1] = $#lines;
                    $indexes[$#indexes][2] = $#lines;
                    $complex = 0;
                    if ($1 ne $field) {
                        pop @indexes;
                        $complex = -1;
                    }
                } elsif ($line =~ /^\s*([a-zA-Z0-9_-]+)\s+(?:[^\)\\]*|\\[^\s])*\s*(?:#.*)?$/) {
                    $indexes[$#indexes][1] = $#lines;
                    $indexes[$#indexes][2] = $#lines;
                    $complex = 0;
                    if ($1 ne $field) {
                        pop @indexes;
                        $complex = -1;
                    }
                } elsif ($line =~ /^\s*([a-zA-Z0-9_-]+)\s*(?:#.*)?$/) {
                    $indexes[$#indexes][1] = $#lines;
                    $complex = 1;
                    if ($1 ne $field) {
                        pop @indexes;
                        $complex = -1;
                    }
                }
            }
        }
        when ("APPVEYOR") {
            if ($is_field) {
                push @indexes, $#lines if ($line =~ /^\s*\Q$field\E:\s*"(?:[^"\\]*|\\[^\s])*"(?:#.*)?$/);
                push @indexes, $#lines if ($line =~ /^\s*\Q$field\E:\s*'(?:[^']*|'')*'(?:#.*)?$/);
            }
        }
        when ("DOCKER") {
            if ($is_field) {
                push @indexes, $#lines if ($line =~ /^\s*ARG\s+\Q$field\E=".*"\s*(?:#.*)?$/);
            }
        }
        when ("ABUILD") {
            push @indexes, $#lines if ($line =~ /^\Q$field\E=".*"$/);
        }
    }
}

# Simple line substitution for RPM sections (force skip)
my $skip = 0;
if ($document eq "RPMBUILD" && $is_complex && @indexes > 0) {
    my @contiguous = shift @indexes;
    foreach my $i (0 .. $#indexes) {
        if ($indexes[$i] - $contiguous[$i] - 1 == 0) {
            push @contiguous, $indexes[$i];
        } else {
            last;
        }
    }
    my @insertion = split "\n", $value;
    splice @lines, $contiguous[0], scalar @contiguous, @insertion;
    $skip = 1;
}

foreach my $line (0 .. $#lines) {
    if (! $skip && @indexes > 0 ) {
        given ($document) {
            when ("RPMBUILD") {
                if ($is_field) {
                    if ($line == $indexes[$#indexes]) {
                        $lines[$line] =~ s/^(\Q$field\E: +).*$/$1$value/;
                        $skip = 1;
                    }
                } elsif ($is_array) {
                    if ($line == $indexes[0]) {
                        $lines[$line] =~ s/^(\Q$field\E: +).*$/$1$value/;
                        $skip = 1;
                    }
                } elsif (! $is_complex) {
                    $lines[$line] =~ s/^(%(global|define) +\Q$field\E +).+$/$1$value/ if ($line == $indexes[$#indexes]);
                }
            }
            when ("PKGBUILD") {
                if ($is_array) {
                    if ($line == $indexes[0]) {
                        $lines[$line] =~ s/^(\Q$field\E=\(").*("\).*)$/$1$value$2/;
                        $skip = 1;
                    }
                } elsif ($is_number) {
                    if ($line == $indexes[$#indexes]) {
                        $lines[$line] =~ s/^(\Q$field\E=).*$/$1$value/;
                        $skip = 1;
                    }
                } else {
                    if ($line == $indexes[$#indexes]) {
                        $lines[$line] =~ s/^(\Q$field\E=").*(".*)$/$1$value$2/;
                        $skip = 1;
                    }
                }
            }
            when ("APKBUILD") {
                if ($is_array) {
                    if ($line == $indexes[0]) {
                        $lines[$line] =~ s/^(\Q$field\E=\(").*("\).*)$/$1$value$2/;
                        $skip = 1;
                    }
                } elsif ($is_number) {
                    if ($line == $indexes[$#indexes]) {
                        $lines[$line] =~ s/^(\Q$field\E=).*$/$1$value/;
                        $skip = 1;
                    }
                } else {
                    if ($line == $indexes[$#indexes]) {
                        $lines[$line] =~ s/^(\Q$field\E=").*(".*)$/$1$value$2/;
                        $skip = 1;
                    }
                }
            }
            when ("CMAKE") {
                my ($start, $k, $v, $end) = @{$indexes[$#indexes]};
                if ($line == $start && $line == $k && $line == $v) {
                    my $res = $lines[$line] =~ s/^(\s*(?:set|SET)\s*\(\s*\Q$field\E\s+")(?:[^"\\]*|\\[^\s])*("\s*\)\s*(?:#.*)?)$/$1$value$2/;
                    if (! $res) {
                        $lines[$line] =~ s/^(\s*(?:set|SET)\s*\(\s*\Q$field\E\s+)(?:[^\)\\]*|\\[^\s])*(\s*\)\s*(?:#.*)?)$/$1$value$2/;
                    }
                    $skip = 1;
                } elsif ($line == $k && $line == $v) {
                    my $res = $lines[$line] =~ s/^(\s*\Q$field\E\s+")(?:[^"\\]*|\\[^\s])*("\s*\)\s*(?:#.*)?)$/$1$value$2/;
                    if (! $res) {
                        $lines[$line] =~ s/^(\s*\Q$field\E\s+)(?:[^\)\\]*|\\[^\s])*(\s*\)\s*(?:#.*)?)$/$1$value$2/;
                    }
                    $skip = 1;
                } elsif ($line == $v) {
                    my $res = $lines[$line] =~ s/^(\s*")(?:[^"\\]*|\\[^\s])*("\s*\)\s*(?:#.*)?)$/$1$value$2/;
                    if (! $res) {
                        $lines[$line] =~ s/^(\s*)(?:[^\)\\]*|\\[^\s])*(\s*\)\s*(?:#.*)?)$/$1$value$2/;
                    }
                    $skip = 1;
                }
            }
            when ("APPVEYOR") {
                if ($line == $indexes[$#indexes]) {
                    my $res = $lines[$line] =~ s/^(\s*\Q$field\E:\s*")(?:[^"\\]*|\\[^\s])*("(?:#.*)?)$/$1$value$2/;
                    if (! $res) {
                        $lines[$line] =~ s/^(\s*\Q$field\E:\s*')(?:[^']*|'')*('(?:#.*)?)$/$1$value$2/;
                    }
                }
            }
            when ("DOCKER") {
                if ($line == $indexes[$#indexes]) {
                    my $res = $lines[$line] =~ s/^(\s*ARG\s+\Q$field\E=")(?:[^"\\]*|\\[^\s])*("(?:#.*)?)$/$1$value$2/;
                    if (! $res) {
                        $lines[$line] =~ s/^(\s*ARGC\s+\Q$field\E=\s*')(?:[^']*|'')*('(?:#.*)?)$/$1$value$2/;
                    }
                }
            }
            when ("ABUILD") {
                if ($line == $indexes[$#indexes]) {
                    $lines[$line] =~ s/^(\Q$field\E=").*(".*)$/$1$value$2/;
                    $skip = 1;
                }
            }
        }
    }
    if (exists $lines[$line]) {
        print "$lines[$line]\n";
    } else {
        print "\n";
    }
}
