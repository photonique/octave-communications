#!/usr/bin/env perl
#
# David Bateman Feb 02 2003
# 
# Extracts the help in texinfo format from *.cc and *.m files for use
# in documentation. Based on make_index script from octave_forge.

use strict;
use File::Find;
use File::Basename;
use FileHandle;

my $docdir = ".";
if (@ARGV) {
  $docdir = @ARGV[0];
}

# locate all C++ and m-files in current directory
my @m_files = ();
my @C_files = ();
find(\&cc_and_m_files, $docdir);

sub cc_and_m_files { # {{{1 populates global array @files
    return unless -f and /\.(m|cc)$/;  # .m and .cc files
    my $path = "$File::Find::dir/$_";
    $path =~ s|^[.]/||;
    if (/\.m$/) {
        push @m_files, $path;
    } else {
        push @C_files, $path;
    }
} # 1}}}

# grab help from C++ files
foreach my $f ( @C_files ) {
  # XXX FIXME XXX. Should run the preprocessor over the file first, since 
  # the help might include defines that are compile dependent.
    if ( open(IN,$f) ) {
	while (<IN>) {
	    # skip to the next function
	    next unless /^DEFUN_DLD/;

	    # extract function name to pattern space
	    /\((\w*)\s*,/;
	    # remember function name
	    my $function = $1;
	    # skip to next line if comment doesn't start on this line
	    # XXX FIXME XXX maybe we want a loop here?
	    $_ = <IN> unless /\"/;
	    # skip to the beginning of the comment string by
	    # chopping everything up to opening "
	    my $desc = $_;
            $desc =~ s/^[^\"]*\"//;
	    # join lines until you get the end of the comment string
	    # plus a bit more.  You need the "plus a bit more" because
	    # C compilers allow implicitly concatenated string constants
	    # "A" "B" ==> "AB".
	    while ($desc !~ /[^\\]\"\s*\S/ && $desc !~ /^\"/) {
		# if line ends in '\', chop it and the following '\n'
		$desc =~ s/\\\s*\n//;
		# join with the next line
		$desc .= <IN>;
		# eliminate consecutive quotes, being careful to ignore
		# preceding slashes. XXX FIXME XXX what about \\" ?
		$desc =~ s/([^\\])\"\s*\"/$1/;
	    }
	    $desc = "" if $desc =~ /^\"/; # chop everything if it was ""
	    $desc =~ s/\\n/\n/g;          # insert fake line ends
	    $desc =~ s/([^\"])\".*$/$1/;  # chop everything after final '"'
	    $desc =~ s/\\\"/\"/;          # convert \"; XXX FIXME XXX \\"
	    $desc =~ s/$//g;		  # chop trailing ...

	    if (!($desc =~ /^\s*-[*]- texinfo -[*]-/)) {
		my $err = sprintf("Function %s, does not contain texinfo help\n",
				$function);
		print STDERR "$err";
	    }
	    my $entry = sprintf("\037%s\n%s", $function, $desc);
	    print "$entry", "\n";
	}
	close (IN);
    } else {
	print STDERR "Could not open file ($f): $!\n";
    }
}

# grab help from m-files
foreach my $f ( @m_files ) {
    my $desc     = extract_description($f);
    my $function = basename($f, ('.m'));
    die "Null function?? [$f]\n" unless $function;
    if (!($desc =~ /^\s*-[*]- texinfo -[*]-/)) {
	my $err = sprintf("Function %s, does not contain texinfo help\n",
				$function);
	print STDERR "$err";
    }
    my $entry = sprintf("\037%s\n%s", $function, $desc);
    print "$entry", "\n";
}

sub extract_description { # {{{1
# grab the entire documentation comment from an m-file
    my ($file) = @_;
    my $retval = '';

    if( open( IN, "$file")) {
	# skip leading blank lines
	while (<IN>) {
	    last if /\S/;
	}
	if( m/\s*[%\#][\s\#%]* Copyright/) {
	    # next block is copyright statement, skip it
	    while (<IN>) {
		last unless /^\s*[%\#]/;
	    }
	}
	# Skip everything until the next comment block
	while ( !/^\s*[\#%]+\s/ ) {
	    $_ = <IN>;
	    last if not defined $_;
	}
        # Return the next comment block as the documentation
        while (/^\s*[\#%]+\s/) {
            s/^\s*[%\#]+\s//; # strip leading comment characters
            s/[\cM\s]*$//;    # strip trailing spaces.
	    s/[\.*]$//;
	    $retval .= "$_\n";
	    $_ = <IN>;
	    last if not defined $_;
	}
        close(IN);
	return $retval;
    }
    else {
	print STDERR "Could not open file ($file): $!\n";
    }
} # 1}}}
__END__
This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program; if not, see <http://www.gnu.org/licenses/>.
This program is granted to the public domain.
THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
SUCH DAMAGE.
