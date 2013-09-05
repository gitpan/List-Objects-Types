use strict; use warnings FATAL => 'all';

use Test::More;
use Test::TypeTiny;

use Types::Standard -types;

use List::Objects::Types -all;
use List::Objects::WithUtils qw/
  array
  array_of
  immarray
  hash
  hash_of
/;

# array/hash
should_pass array(), ArrayObj;
should_pass hash(),  HashObj;

# immarray
ok_subtype ArrayObj, ImmutableArray;
should_pass immarray(), ArrayObj;
should_pass immarray(), ImmutableArray;

# array_of
my $typed = array_of(Int() => 1 .. 4);
should_pass $typed, ArrayObj;
should_pass $typed, TypedArray;
should_pass $typed, TypedArray[Num];
should_pass $typed, TypedArray[Int];
should_fail $typed, TypedArray[GlobRef];

# hash_of
my $htyped = hash_of(Int() => ( foo => 1, baz => 2 ) );
should_pass $htyped, HashObj;
should_pass $htyped, TypedHash;
should_pass $htyped, TypedHash[Num];
should_pass $htyped, TypedHash[Int];
should_fail $htyped, TypedHash[GlobRef];

# failures
should_fail [],  ArrayObj;
should_fail [],  ImmutableArray;
should_fail [],  TypedArray;
should_fail array(), ImmutableArray;
should_fail array(), TypedArray;
should_fail +{}, HashObj;
should_fail +{}, TypedHash;
should_fail hash(), TypedHash;

# unions
should_pass [],       (ArrayRef | ArrayObj);
should_pass array(),  (ArrayRef | ArrayObj);
should_fail 'foo',    (ArrayRef | ArrayObj);

# helpers
ok is_ArrayObj(array), 'is_ArrayObj ok';
ok is_HashObj(hash),   'is_HashObj ok';
ok is_ImmutableArray(immarray), 'is_ImmutableArray ok';

# coercions
my $coerced = ArrayObj->coerce([]);
ok $coerced->count == 0, 'ArrayRef coerced to ArrayObj ok';

$coerced = ImmutableArray->coerce($coerced);
ok is_ImmutableArray($coerced), 'ArrayObj coerced to ImmutableArray ok';
$coerced = ImmutableArray->coerce([]);
ok is_ImmutableArray($coerced), 'ArrayRef coerced to ImmutableArray ok';

$coerced = HashObj->coerce(+{});
ok $coerced->keys->count == 0, 'HashRef coerced to HashObj ok';

my $RoundedInt = Int->plus_coercions(Num, 'int($_)');
$coerced = (TypedArray[$RoundedInt])->coerce([ 1, 2, 3, 4.1 ]);
should_pass $coerced, TypedArray[Int];
is_deeply(
  [  $coerced->all ],
  [ 1..4 ],
  'TypedArray inner coercions worked',
);

$coerced = (TypedHash[$RoundedInt])->coerce(
  { foo => 1, bar => 2, baz => 3.14}
);
should_pass $coerced, TypedHash[Int];
is_deeply(
  +{ $coerced->export },
  +{ foo => 1, bar => 2, baz => 3 },
  'TypedHash inner coercions worked'
);

done_testing;
