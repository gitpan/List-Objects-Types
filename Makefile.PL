
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Type::Tiny-based types for List::Objects::WithUtils",
  "AUTHOR" => "Jon Portnoy <avenj\@cobaltirc.org>",
  "BUILD_REQUIRES" => {},
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "List-Objects-Types",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "List::Objects::Types",
  "PREREQ_PM" => {
    "List::Objects::WithUtils" => 2,
    "Type::Library" => 0,
    "Type::Tiny" => "0.022",
    "Type::Utils" => 0,
    "Types::Standard" => 0
  },
  "TEST_REQUIRES" => {
    "Test::More" => "0.88"
  },
  "VERSION" => "1.002001",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "List::Objects::WithUtils" => 2,
  "Test::More" => "0.88",
  "Type::Library" => 0,
  "Type::Tiny" => "0.022",
  "Type::Utils" => 0,
  "Types::Standard" => 0
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



