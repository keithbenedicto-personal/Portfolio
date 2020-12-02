# PyIPCalc
#
# Copyright (c) 2017, Christiaan Frans Rademan, Dave Kruger.
# All rights reserved.
#
# LICENSE: (BSD3-Clause)
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
# 3. Neither the name of the copyright holder nor the names of its contributors
#    may be used to endorse or promote products derived from this software
#    without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENTSHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
from __future__ import absolute_import
from __future__ import division
from __future__ import print_function
from __future__ import unicode_literals

import sys
import logging
import argparse

from pyipcalc import metadata
from pyipcalc import Error
from pyipcalc import IPPrefixError
from pyipcalc import IPInvalidError
from pyipcalc import BitLengthError
from pyipcalc import InvalidVersionError

log = logging.getLogger(__name__)


def detect_version(ip):
    """Detect IP Version.

    Args:
        ip (str): IPv4 / IPv6 Address.

    Returns:
        int: IP version 4 / 6.
    """

    if ":" in ip:
        return 6
    elif "." in ip:
        return 4
    else:
        raise IPPrefixError(ip)


def validate_ip(ip):
    """Validates and returns formatted IP.

    Args:
        ip (str): IPv4 / IPv6 Address.

    Returns:
        string: Formatted IP Address.
    """

    version = detect_version(ip)

    if version == 4:
        validate_ip = ip.split('.')
        if len(validate_ip) == 4:
            for value in validate_ip:
                try:
                    value = int(value)
                except:
                    raise IPInvalidError(ip)

                if value > 255 or value < 0:
                    raise IPInvalidError(ip)
        else:
            raise IPInvalidError(ip)

        return ip

    elif version == 6:
        if '::' in ip:
            b, e = ip.split('::')
            ip_values = len(b.split(':')) + len(e.split(':'))
            diff = 8 - ip_values
            add = '0000:' * diff
            if e == '':
                e = '0000'

            ip = "%s:%s%s" % (b, add, e)

        validate_ip = ip.split(':')
        for value in validate_ip:
            try:
                value = int(value, 16)
            except:
                raise IPInvalidError(ip)

            if value > 65535 or value < 0:
                raise IPInvalidError(ip)


        if len(validate_ip) != 8:
            raise IPInvalidError(ip)

        for value in validate_ip:
            if len(value) > 4:
                raise IPInvalidError(ip)

        return ip


def bit_length(bits, version=4):
    """Number of addresses in CIDR bits.

    Args:
        bits (int): Bits. (example 24)
        version (int): IP Version.

    Returns:
        int: Number of addresses in bits.
    """

    try:
        bits = int(bits)
    except:
        raise BitLengthError(bits, version)

    try:
        version = int(version)
    except:
        raise InvalidVersionError(version)

    if version == 4:
        size = 32
    elif version == 6:
        size = 128
    else:
        raise InvalidVersionError(version)

    if bits > size:
        raise BitLengthError(bits, version)

    if size is not None:
        ips = 1 << (size - bits)
        return ips


def checkIndex(key, ipn):
    """ Function to fixup the index for getitem

    :param key: index entry of list
    :param size: Subnet size
    :return: integer of fixed up key
    """
    # Users have the ability to either specify
    # Integer or IPNetwork object as slice.
    if isinstance(key, IPNetwork):
        if key not in ipn:
            raise IndexError("index out of range")
        else:
            key = key._ip - ipn._network
    else:
        if abs(key) > ipn._size:
            raise IndexError("index out of range")
        elif key < 0:
            # When key is negative, we want -1 to be
            # the last (broadcast) address. Since ._size
            # is one less than the actual total number
            # of addresses in the subnet, we add 1
            key = ipn._size + 1 + key
    return key


def getItem(ipn, key):
    """getItem implementation

    :param ipn: (int) IPv4 / IPv6 Network object
    :param key: integer or slice object
    :return: IPNetwork object, or list in the case of slice
    """
    if isinstance(key, int):
        key = checkIndex(key, ipn)
        return IPNetwork(int_to_ip(ipn._network + key, ipn.version()))
    elif isinstance(key, slice):
        start = checkIndex(key.start, ipn) if key.start is not None else None
        stop = checkIndex(key.stop, ipn) if key.stop is not None else None
        ipn = IPIter(ipn.prefix(),
                     start = start,
                     blocks = key.step,
                     stop = stop)
        return [ip for ip in ipn]


def ip_to_int(ip):
    """Convert IP to Integer representation.

    Args:
        ip (str): IPv4 / IPv6 Address.

    Returns:
        int: IP integer value.
    """

    version = detect_version(ip)
    ip = validate_ip(ip)

    if version == 4:
        ip = ip.split('.')

        num = 0
        for (i, value) in enumerate(ip):
            part = 8 * (i+1)
            value = int(value) * bit_length(part, 4)
            num = value + num
        return num

    elif version == 6:
        ip = ip.split(':')
        num = 0
        for (i, value) in enumerate(ip):
            part = ((16) * (i+1))
            if value == '':
                value = 0
            value = int(str(value), 16)
            value = value * bit_length(part, 6)
            num = value + num
        return num


def int_to_ip(ip, version=4):
    """Convert Integer to IP representation.

    Args:
        ip (int): IPv4 / IPv6 Address.
        version (int): IP Version.

    Returns:
        string: Human readable formatted IP Address.
    """

    try:
        version = int(version)
    except:
        raise InvalidVersionError(version)

    if version == 4:
        ip1 = ip >> 24 & 0xff
        ip2 = ip >> 16 & 0xff
        ip3 = ip >> 8 & 0xff
        ip4 = ip & 0xff
        return "%s.%s.%s.%s" % (ip1, ip2, ip3, ip4)
    if version == 6:
        ip1 = ip >> 112 & 0xffff
        ip2 = ip >> 96 & 0xffff
        ip3 = ip >> 80  & 0xffff
        ip4 = ip >> 64  & 0xffff
        ip5 = ip >> 48 & 0xffff
        ip6 = ip >> 32  & 0xffff
        ip7 = ip >> 16  & 0xffff
        ip8 = ip & 0xffff

        return("%s:%s:%s:%s:%s:%s:%s:%s" %
               (str(hex(ip1))[2:].rstrip('L').zfill(4),
                str(hex(ip2))[2:].rstrip('L').zfill(4),
                str(hex(ip3))[2:].rstrip('L').zfill(4),
                str(hex(ip4))[2:].rstrip('L').zfill(4),
                str(hex(ip5))[2:].rstrip('L').zfill(4),
                str(hex(ip6))[2:].rstrip('L').zfill(4),
                str(hex(ip7))[2:].rstrip('L').zfill(4),
                str(hex(ip8))[2:].rstrip('L').zfill(4)))


def int_128_to_64(ip):
    """Binary split 128 bit integer to two 64bit values.

    This is used for storing 128bit IP Addressses in integer format in
    database. Its easier to search integer values.

    Args:
        ip (int): IPv4 / IPv6 Address.

    Returns:
        tuple: (first 64bits, last 64bits)
    """

    int1 = ip >> 64
    int2 = ip & (1 << 64) - 1

    return (int1, int2)


def int_64_to_128(val1, val2):
    """Binary join 128 bit integer from two 64bit values.

    This is used for storing 128bit IP Addressses in integer format in
    database. Its easier to search integer values.

    Args:
        val1 (int): First 64Bits.
        val2 (int): Last 64Bits.

    Returns:
        int: IP integer value.
    """

    return (val1 << 64) + val2

def int_128_to_32(ip):
    """Binary split 128 bit integer to 4 32bit values.

    This is used for storing 128bit IP Addressses in integer format in
    database. Its easier to search integer values.

    Args:
        ip (int): IPv4 / IPv6 Address.

    Returns:
        tuple: (first 32bits, second 32bits, third 32 bits, last 32bits)
    """
    int1 = ip >> 96
    int2 = (ip & 0xffffffff0000000000000000) >> 64
    int3 = (ip & 0xffffffff00000000) >> 32
    int4 = ip & 0xffffffff

    return (int1, int2, int3, int4)

def int_32_to_128(val1, val2, val3, val4):
    """Binary join 128 bit integer from four 32bit values.

    This is used for storing 128bit IP Addressses in integer format in
    database. Its easier to search integer values.

    Args:
        val1 (int): First 32Bits.
        val2 (int): Second 32Bits.
        val3 (int): Third 32Bits.
        val4 (int): Last 32Bits.

    Returns:
        int: IP integer value.
    """

    return (val1 << 96) + (val2 << 64) + (val3 << 32) + val4

def supernet(ipn1, ipn2, min_bits=None):
    """Create supernet IPNetwork Object based on two IPNetwork Objects.

    Args:
        ipn1 (IPNetwork): IPNetwork Object.
        ipn2 (IPNetwork): IPNetwork Object.

    Returns:
        IPNetwork: Supernet Object.
    """

    for ip in (ipn1, ipn2):
        if not type(ip) is IPNetwork:
            raise IPPrefixError(ip)
    if ipn1._version != ipn2._version:
        raise IPPrefixError(str(ipn1), str(ipn2))

    if ipn1.contains(ipn2):
        return ipn1
    elif ipn2.contains(ipn1):
        return ipn2
    else:
        if ipn1._version == 4:
            bitlength = 32
            min_bits = min_bits if isinstance(min_bits, int) else 8
        elif ipn1._version == 6:
            bitlength = 128
            min_bits = min_bits if isinstance(min_bits, int) else 16
        mask = (1 << ipn1._bits) - 1
        mask <<= bitlength - ipn1._bits
        pl = (1 << bitlength) - 1
        d1 = ip_to_int(ipn1.network())
        d2 = ip_to_int(ipn2.network())
        min_bits = ipn1._bits - min_bits
        i = 0
        d1net = d1 & mask
        while d1net != d2 & mask and i < min_bits:
                i += 1
                mask <<= 1
                mask &= pl
                d1net = d1 & mask
        if d1net == d2 & mask:
            bits = ipn1._bits - i
            return IPNetwork(int_to_ip(d1net, ipn1._version) + "/" + str(bits))
        else:  # we did not find a common supernet within the search limits
            return None


def mask_to_bits(mask):
    """Convert IPv4 Subnet Mask to CIDR Bit Length.

    Args:
        mask (string): IPv4 Subnet Mask. (example: 255.255.255.0)

    Returns:
        int: Bit Length. (example 24)
    """

    int_mask = ip_to_int(mask)
    size = ((1 << 32) - int_mask - 1).bit_length()

    return 32 - size


def bits_int_mask(bits, version):
    """Convert CIDR Bit Length to Integer Mask.

    Args:
        bits (int): Bits. (example 24)
        version (int): IP Version.

    Returns:
        int: IP Integer Mask.
    """

    try:
        version = int(version)
    except:
        raise InvalidVersionError(version)

    try:
        bits = int(bits)
    except:
        raise BitLengthError(bits)

    if version == 4:
        left_shift = 32 - bits
    elif version == 6:
        left_shift = 128 - bits
    else:
        return None
    mask = (1 << bits) - 1
    mask <<= left_shift
    return mask


class IPIter(object):
    """Iteration Class for IPNetwork.

    Args:
        prefix (str): IPv4 / IPv6 Prefix. (example 196.25.1.0/24)
        blocks (int): Iteration bit size.
    """

    def __init__(self, prefix, blocks=None, start=None, stop=None):
        self._version = detect_version(prefix)

        if blocks is None:
            if self._version == 4:
                blocks = 32
            else:
                blocks = 128

        if start is None:
            start = 0

        self._prefix = prefix
        self._ip, self._bits = self._prefix.split('/')
        self._ip = validate_ip(self._ip)
        self._bits = int(self._bits)

        self._blocks = bit_length(blocks, self._version)
        self._blocks_bits = blocks
        self._size = bit_length(self._bits, self._version)
        self._int = ip_to_int(self._ip)

        if stop is None:
            self._intend = self._int + self._size - 1
        else:
            self._intend = self._int + stop

        self._int += start

    def __iter__(self):
        return self

    def __next__(self):
        return self.next()

    def next(self):
        if self._int > self._intend:
            raise StopIteration
        else:
            ip = int_to_ip(self._int, self._version)
            self._int += self._blocks
            net = "%s/%s" % (ip, self._blocks_bits)
            net = IPNetwork(net)
            return net


class IPNetwork(object):
    """IPNetwork Class.

    Args:
        prefix (str): IPv4 / IPv6 Prefix. (example 196.25.1.0/24)
                      If no prefix is given, host prefix is assumed
    """

    def __init__(self, prefix):
        self._version = detect_version(prefix)

        if not '/' in prefix:
            if self._version == 4:
                self._bits = "32"
            else:
                self._bits = "128"
            prefix += '/' + self._bits

        try:
            self._ip, self._bits = prefix.split('/')
        except ValueError:
            raise IPPrefixError(prefix)

        try:
            self._bits = int(self._bits)
        except:
            raise BitLengthError(self._bits, self._version)

        self._ip = validate_ip(self._ip)
        self._ip = ip_to_int(self._ip)
        self._mask = bits_int_mask(self._bits, self._version)
        self._network = self._ip & self._mask
        self._size = bit_length(self._bits, self._version) - 1

    def __add__(self, netobj):
        return supernet(self, netobj)

    def __getitem__(self, key):
        return getItem(self, key)

    def __iter__(self):
        return IPIter(self.prefix())

    def __string__(self):
        return str(self.prefix())

    def __repr__(self):
        return str(self.prefix())

    def __str__(self):
        return str(self.prefix())

    def prefix(self):
        """Network Prefix.

        Returns:
            string: Network Prefix.
        """

        return("%s/%s" % (int_to_ip(self._network, self._version),
                          self._bits))

    def network(self):
        """Network Address.

        Returns:
            string: Network Address.
        """

        return(int_to_ip(self._network, self._version))

    def broadcast(self):
        """Broadcast Address.

        Returns:
            string: Broadcast Address.
        """

        if self._version == 4:
            size = self._size.bit_length()
            return int_to_ip((self._network + (1 << size)) - 1)
        else:
            return None

    def first(self):
        """First IP Address.

        Returns:
            string: First IP Address.
        """

        if self._version == 4:
            if self._size > 1:
                return(int_to_ip(self._network + 1, self._version))
            else:
                return(int_to_ip(self._network, self._version))
        else:
            return(int_to_ip(self._network, self._version))


    def last(self):
        """Last IP Address.

        Returns:
            string: Last IP Address.
        """

        size = self._size.bit_length()
        if self._version == 4:
            if self._size == 1:
                return int_to_ip((self._network + (1 << size)) - 1)
            if self._size > 1:
                return int_to_ip((self._network - 1 + (1 << size)) - 1)
            else:
                return(int_to_ip(self._network, self._version))
        else:
            return int_to_ip((self._network + (1 << size) - 1),
                             self._version)

    def version(self):
        """IP Version.

        Returns:
            int: IP Version.
        """

        return self._version

    def mask(self):
        """IPv4 subnet mask.

        Returns:
            string: IPv4 subnet mask.
        """

        return int_to_ip(self._mask,self._version)

    def __contains__(self, ip):
        if not type(ip) is IPNetwork:
            raise IPPrefixError(ip)
        if self._version != ip._version:
            raise IPPrefixError(ip)

        if self._network & self._mask == ip._network & self._mask and \
                self._bits <= ip._bits:
            return True

        return False

    def contains(self, ip):
        return self.__contains__(ip)


def main(argv):
    app = "\033[1;32;40mPyIPCalc %s\033[0m" % (metadata.version,)
    parser = argparse.ArgumentParser(description=app)
    parser.add_argument('prefix', help='IPv4 / IPv6 in CIDR Notation')
    parser.add_argument('mask', help='Subnet mask (IPv4 only)', nargs='?')
    args = parser.parse_args()
    if args is not None:
        print("%s\n" % app)
        try:
            if args.mask is not None:
                cidr = mask_to_bits(args.mask)
                if '/' not in args.prefix:
                    ipn = IPNetwork('%s/%s' % (args.prefix, cidr))
                else:
                    ipn = IPNetwork(args.prefix)
            else:
                ipn = IPNetwork(args.prefix)
            print("\t\033[1mNetwork Prefix: \033[0;33;40m%s\033[0m" % (ipn.prefix(),))
            print("\t\033[1mNetwork Address: \033[0;33;40m%s\033[0m" % (ipn.network(),))
            print("\t\033[1mFirst IP Address: \033[0;33;40m%s\033[0m" % (ipn.first(),))
            print("\t\033[1mLast IP Address: \033[0;33;40m%s\033[0m" % (ipn.last(),))
            print("\t\033[1mBroadcast Address: \033[0;33;40m%s\033[0m" % (ipn.broadcast(),))
            print("\t\033[1mNetmask: \033[0;33;40m%s\033[0m" % (ipn.mask(),))
            print("")
        except Error as e:
            print("\t\033[1;31m%s\033[0m" % (e,))
            print("")


def entry_point():
    """Zero-argument entry point for use with setuptools/distribute."""
    raise SystemExit(main(sys.argv))


if __name__ == '__main__':
    entry_point()
