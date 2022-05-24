" BSD 2-Clause License

" Copyright (c) 2022, Florian Begusch
" All rights reserved.

" Redistribution and use in source and binary forms, with or without # modification, are permitted provided that the following conditions are met:

" * Redistributions of source code must retain the above copyright notice, this
  " list of conditions and the following disclaimer.

" * Redistributions in binary form must reproduce the above copyright notice,
  " this list of conditions and the following disclaimer in the documentation
  " and/or other materials provided with the distribution.

" THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
" IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
" DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
" FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
" DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
" SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
" CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
" OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
" OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

function <SID>PrimitiveYamlSort()
  py3 << EOF

from ruamel.yaml import YAML

# select line before and after to have regex
# pattern match first and last element properly
start = vim.current.buffer.mark('<')[0] - 1
if start < 0: start = 0
end = vim.current.buffer.mark('>')[0] + 1

buffer_range = vim.current.buffer[start:end]
line_count_initial = len(buffer_range)

content = '\n'.join(buffer_range)

yaml = YAML()
yaml.indent(mapping=2, sequence=4, offset=2)
parsed = yaml.load(content)

try:
  sorted_yaml = sorted(parsed, key=lambda member: member['name'].lower())
except:
  sorted_yaml = sorted(parsed, key=lambda member: member['mail'].lower())

import io
with io.StringIO() as output:
  yaml.dump(sorted_yaml, output)

  # replace buffer content
  # vim.current.buffer[start:end] = yaml.dump(sorted_yaml).splitlines()
  vim.current.buffer[start:end] = output.getvalue().splitlines()

EOF
endfunction

command -range PrimitiveYamlSort :call <SID>PrimitiveYamlSort()
