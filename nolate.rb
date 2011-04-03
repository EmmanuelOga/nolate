# NOLATE, A NO LAme TEmplate system
#
# Please read the README file for more information
#
# Copyright (c) 2011, Salvatore Sanfilippo <antirez at gmail dot com>
#
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
# 
#  *  Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
#
#  *  Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in the
#     documentation and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

$nlt_templates = {}

def nolate_empty_binding
    return binding()
end

def nolate_parse(str)
    i = -1
    str.split(/<%([=#].*?)%>/).map do |s|
        i = i + 1
        if i % 2 == 0 then        [s]
        elsif s[1].ord == 32 then [:eval, s[1..-1]]
        else                      [:sub, s[1..-1].to_sym]
        end
    end
end

def nolate_eval(template, sub = {})
    b = nolate_empty_binding
    template.map do |action, param|
        case action
        when :eval then eval(param, b, __FILE__, __LINE__)
        when :sub  then sub[param]
        else action
        end
    end.join
end

def nolate(str, sub={})
    nolate_eval(nolate_parse(str), sub)
end

def nlt(viewname,sub={})
    viewname = viewname.to_s
    if !$nlt_templates[viewname]
        filename = "views/"+viewname
        if !File.exists?(filename)
            raise "NOLATE error: no template at #{filename}"
        end
        $nlt_templates[viewname] = nolate_parse(File.open(filename).read)
    end
    nolate_eval($nlt_templates[viewname],sub)
end

def nlt_flush_templates
    $nlt_templates = {}
end
