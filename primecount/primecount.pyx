r"""
Interface to the primecount library
"""
#*****************************************************************************
#       Copyright (C) 2018 Vincent Delecroix <20100.delecroix@gmail.com>
#
#  Distributed under the terms of the GNU General Public License (GPL)
#  as published by the Free Software Foundation; either version 2 of
#  the License, or (at your option) any later version.
#                  http://www.gnu.org/licenses/
#*****************************************************************************

from libc.stdint cimport int64_t
from libcpp.string cimport string as cppstring
from cpython.int cimport PyInt_FromString

from cysignals.signals cimport sig_on, sig_off
cimport defs as pcount

cdef inline int _do_sig(int64_t n):
    "threshold for sig_on/sig_off"
    return n >> 26

cpdef int64_t prime_pi(int64_t n, method=None) except -1:
    r"""
    Return the number of prime numbers smaller or equal than ``n``.

    INPUT:

    - ``n`` - an integer

    EXAMPLES::

        sage: from sage.interfaces.primecount import prime_pi
        sage: prime_pi(1000) == 168
        True
        sage: prime_pi(1000, method='deleglise_rivat') == 168
        True
    """
    cdef int64_t ans
    if _do_sig(n): sig_on()
    ans = pcount.pi(n)
    if _do_sig(n): sig_off()
    return ans

cpdef prime_pi_128(n):
    r"""
    Return the number of prime number smaller than ``n``.

    EXAMPLES::

        sage: from sage.interfaces.primecount import prime_pi_128

        sage: prime_pi_128(1000)
        168
        sage: nth_prime_128(2**65)   # not tested
        ?
    """
    cdef cppstring s = str(n).encode('ascii')
    cdef bytes ans
    sig_on()
    ans = pcount.pi(s)
    sig_off()
    return PyInt_FromString(ans, NULL, 10)

cpdef int64_t nth_prime(int64_t n) except -1:
    r"""
    Return the ``n``-th prime integer.

    EXAMPLES::

        sage: from sage.interfaces.primecount import nth_prime

        sage: nth_prime(168) == 997
        True
    """
    if n <= 0:
        raise ValueError("n must be positive")

    cdef int64_t ans
    if _do_sig(n): sig_on()
    ans = pcount.nth_prime(n)
    if _do_sig(n): sig_off()
    return ans

cpdef int64_t phi(int64_t x, int64_t a):
    r"""
    Return the number of integers smaller or equal than ``x`` by any of the
    first ``a`` primes.

    This is sometimes called a "partial sieve function" or "Legendre-sum".

    EXAMPLES::

         sage: from sage.interfaces.primecount import phi

         sage: phi(1000, 3) == 266
         True
         sage: phi(2**30, 100) == 95446716
         True
    """
    return pcount.phi(x, a)
