;; Overrides nvim-treesitter (master branch) markdown injections, which use the
;; #set-lang-from-info-string! directive that core Neovim 0.12 does not understand,
;; producing a nil injection node -> "attempt to call method 'range' (a nil value)"
;; crash on every .md/.mdx open. This is a verbatim copy of core nvim's working
;; query (runtime/queries/markdown{,_inline}/injections.scm). Non-extends => wins in
;; rtp over the plugin's. Safe to delete once nvim-treesitter is migrated to its
;; main branch (which is the supported path on nvim 0.11+).

((html_tag) @injection.content
  (#set! injection.language "html")
  (#set! injection.combined))

((latex_block) @injection.content
  (#set! injection.language "latex")
  (#set! injection.include-children))
