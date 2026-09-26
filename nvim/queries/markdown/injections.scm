;; Overrides nvim-treesitter (master branch) markdown injections, which use the
;; #set-lang-from-info-string! directive that core Neovim 0.12 does not understand,
;; producing a nil injection node -> "attempt to call method 'range' (a nil value)"
;; crash on every .md/.mdx open. This is a verbatim copy of core nvim's working
;; query (runtime/queries/markdown{,_inline}/injections.scm). Non-extends => wins in
;; rtp over the plugin's. Safe to delete once nvim-treesitter is migrated to its
;; main branch (which is the supported path on nvim 0.11+).

(fenced_code_block
  (info_string
    (language) @injection.language)
  (code_fence_content) @injection.content)

((html_block) @injection.content
  (#set! injection.language "html")
  (#set! injection.combined)
  (#set! injection.include-children))

((minus_metadata) @injection.content
  (#set! injection.language "yaml")
  (#offset! @injection.content 1 0 -1 0)
  (#set! injection.include-children))

((plus_metadata) @injection.content
  (#set! injection.language "toml")
  (#offset! @injection.content 1 0 -1 0)
  (#set! injection.include-children))

([
  (inline)
  (pipe_table_cell)
] @injection.content
  (#set! injection.language "markdown_inline"))
