let g:llmctx = " in Rust."
let g:aienvdir = "~/tmp/aienv"
vmap <leader>K :!M==v:count1 =g:aienvdir/llm.sh "":redraw!
vmap <leader>k :!M==v:count1 =g:aienvdir/llm.sh "=g:llmctx reply without explaination.":redraw!
nmap <leader>k V,k
vmap <leader>e :!M==v:count1 =g:aienvdir/llm.sh "=g:llmctx explain it.":redraw!
nmap <leader>d :r!M==v:count1 =g:aienvdir/llm.sh "=g:llmctx reply with short explaination." "show docs for =expand('<cword>')":redraw!

