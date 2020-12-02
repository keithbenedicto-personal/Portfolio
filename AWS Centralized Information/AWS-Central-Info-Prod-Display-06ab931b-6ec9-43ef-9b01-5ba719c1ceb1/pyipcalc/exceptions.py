# PyIPCalc
#
# Copyright (c) 2017, Christiaan Frans Rademan.
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


class Error(Exception):
    def __init__(self, description):
        Exception.__init__(self, description)
        self.description = description

    def __str__(self):
        return str(self.description)


class IPPrefixError(Error):
    def __init__(self, prefix):
        self.error = "Prefix Invalid '%s'" % (prefix,)
        Error.__init__(self, self.error)

    def __str__(self):
        return str(self.error)

class IPInvalidError(Error):
    def __init__(self, ip):
        self.error = "IP Invalid '%s'" % (ip,)
        Error.__init__(self, self.error)

    def __str__(self):
        return str(self.error)

class BitLengthError(Error):
    def __init__(self, bits, version):
        self.error = "Invalid Bit Length '%s' version '%s'" % (bits, version)
        Error.__init__(self, self.error)

    def __str__(self):
        return str(self.error)

class InvalidVersionError(Error):
    def __init__(self, version):
        self.error = "Invalid version '%s'" % (version)
        Error.__init__(self, self.error)

    def __str__(self):
        return str(self.error)
