# Copyright 2017 UniCredit S.p.A.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import math, sequtils
import ./core

type Discrete*[A] = object
  values*: ref seq[tuple[value: A, p: float]]

proc discrete*[A](xs: seq[(A, float)]): Discrete[A] =
  new result.values
  result.values[] = @xs

# To make Discrete[A] an instance of RandomVar[A],
# just define `sample`
proc sample*[A](rng: var Random, d: Discrete[A]): A =
  let x = rng.random()
  var sum = 0.0
  for t in d.values[]:
    let (a, p) = t
    sum += p
    if sum >= x:
      return a

# One can also specialize other stats, such as the mean,
# when they are known in advance
proc mean*(rng: var Random, d: Discrete[float], samples = 100000): float =
  d.values[].foldl(a + b.value * b.p, 0.0)