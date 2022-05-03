args@{ config, lib, pkgs, ... }:

with lib;
with types;
let

  makeFtPlugins = ftplugins: with attrsets;
    mapAttrs'
      (key: value: nameValuePair "nvim/after/ftplugin/${key}.vim" ({ text = value; }))
      ftplugins;
in
{
  config = {
    xdg.configFile = makeFtPlugins {
      xml = ''
        setl formatprg=prettier\ --stdin-filepath\ %";
      '';
      sh = ''
        setl makeprg=shellcheck\ -f\ gcc\ %
      '';
      rust = ''
        setl formatprg=rustfmt
        setl makeprg=cargo\ check
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
      '';
      json = ''
        setl formatprg=prettier\ --stdin-filepath\ %
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
      '';
      yaml = ''
        setl formatprg=prettier\ --stdin-filepath\ %
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
      '';
      javascript = ''
        setl formatprg=prettier\ --stdin-filepath\ %
        setl wildignore+=*node_modules*,package-lock.json,yarn-lock.json
        setl errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m,%-G%.%#
        setl makeprg=${pkgs.nodePackages.eslint}/bin/eslint\ --format\ compact
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
      '';
      typescript = ''
        setl formatexpr=
        setl formatprg=prettier\ --parser\ typescript\ --stdin-filepath\ %
        setl wildignore+=*node_modules*,package-lock.json,yarn-lock.json
        setl errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m,%-G%.%#
        setl makeprg=${pkgs.nodePackages.eslint}/bin/eslint\ --format\ compact
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
      '';
      css = ''
        setl formatprg=prettier\ --parser\ css\ --stdin-filepath\ %
      '';
      scss = ''
        setl formatprg=prettier\ --parser\ scss\ --stdin-filepath\ %
      '';
      nix = ''
        setl formatprg=nixpkgs-fmt
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
      '';
      make = ''
        setl noexpandtab
      '';
      python = ''
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
      '';
      sql = ''
        setl formatprg=${pkgs.pgformatter}/bin/pg_format
      '';
      haskell = ''
        setl formatprg=ormolu
      '';
      markdown = ''
        setl formatprg=prettier\ --stdin-filepath\ %
      '';
    };

    programs.neovim = {
      enable = true;
      vimAlias = true;
      viAlias = true;

      extraConfig = ''
        set foldmethod=indent
        set expandtab
        set tabstop=2
        set laststatus=2
        set shiftwidth=2
        set ignorecase
        set smartcase
        set foldlevelstart=99
        set statusline+=\ %f\ %m%=\ %y\ %q\ %3l:%2c\ \|%3p%%\ 
        -- Treesitter
        require'nvim-treesitter.configs'.setup {
          ensure_installed = {},
          highlight = {
            enable = true,
            disable = {"haskell","nix"},
          },
          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = "<C-n>",
              node_incremental = "<C-w>",
              node_decremental = "<A-w>",
            },
          },
          indent = {
            enable = true,
            disable = {"haskell","nix"},
          }
        }
        EOF
      '';

      plugins = with pkgs.vimPlugins; [
        # Syntax
        haskell-vim
	rust-vim
	typescript-vim
	vim-javascript
        vim-jsx-pretty
        vim-jsx-typescript
        vim-nix

        (nvim-treesitter.withPlugins (p: pkgs.tree-sitter.allGrammars))
	coc-nvim
      ];
    };
  };
}
