{ system ? builtins.currentSystem }:
let
	sources = import ./npins;
	pkgs = import sources.nixpkgs { inherit system; config = {}; overlays = []; };
	nixCats = sources.nix-cats;
	
	utils = import nixCats;
	luaPath = ./.;
	
	# see :help nixCats.flake.outputs.categories
	categoryDefinitions = { pkgs, settings, categories, extra, name, mkPlugin, ... }@packageDef: {
		# lspsAndRuntimeDeps:
    # this section is for dependencies that should be available
    # at RUN TIME for plugins. Will be available to PATH within neovim terminal
    # this includes LSPs
		lspsAndRuntimeDeps = {
      general = with pkgs; [ ];
    };
    # This is for plugins that will load at startup without using packadd:
    startupPlugins = {
      general = with pkgs.vimPlugins; [ ];
    };
    # not loaded automatically at startup.
    # use with packadd and an autocommand in config to achieve lazy loading
    optionalPlugins = {
      general = with pkgs.vimPlugins; [ ];
    };
    # shared libraries to be added to LD_LIBRARY_PATH
    # variable available to nvim runtime
    sharedLibraries = {
      general = with pkgs; [ ];
    };
    # environmentVariables:
    # this section is for environmentVariables that should be available
    # at RUN TIME for plugins. Will be available to path within neovim terminal
    environmentVariables = {
      test = {
        CATTESTVAR = "It worked!";
      };
    };
    # If you know what these are, you can provide custom ones by category here.
    # If you dont, check this link out:
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
    extraWrapperArgs = {
      test = [
        '' --set CATTESTVAR2 "It worked again!"''
      ];
    };
    
    # populates $LUA_PATH and $LUA_CPATH
    extraLuaPackages = {
      test = [ (_:[]) ];
    };
	};
	
	# see :help nixCats.flake.outputs.packageDefinitions
	packageDefinitions = {
		nvim = {pkgs, name, mkPlugin, ... }: {
			settings = {
        suffix-path = true;
        suffix-LD = true;
        wrapRc = true;
        aliases = [ "vim" ];
      };
      # and a set of categories that you want
      categories = {
        general = true;
        test = true;
      };
      # anything else to pass and grab in lua with `nixCats.extra`
      extra = {};
		};
	};
	
	defaultPackageName = "nvim";
in utils.baseBuilder luaPath { inherit pkgs; } categoryDefinitions packageDefinitions defaultPackageName
