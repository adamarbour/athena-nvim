{
	sources ? import ./npins,
	system ? builtins.currentSystem,
	...
}:
let
	nixpkgs = import sources.nixpkgs { inherit system; config = {}; overlays = []; };
	
	nixCats = sources.nix-cats;
	utils = import nixCats;
	forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
	
	luaPath = ./.;
	
	# see :help nixCats.flake.outputs.categories
	categoryDefinitions = { pkgs, settings, categories, extra, name, mkPlugin, ... }@packageDef: {
		
		#<startupPlugins>
			# a flexible set of categories, each containing startup plugins.
			# Startup plugins are loaded and can be required.
			# In addition, this can also recieve a superset of the home manager syntax for
			# plugins. see :help nixCats.flake.outputs.categoryDefinitions.schemas below
			# for info
		startupPlugins = with pkgs.vimPlugins; {
      general = [
      		lazy-nvim
      		mini-base16	# Stylix support
      ];
    };
	
		#<optionalPlugins>
			# a flexible set of categories, each containing optional plugins.
			# Optional plugins need to be added with packadd before being required.
			# Use :NixCats pawsible to see the names to use for packadd
			# In addition, this can also recieve a superset of the home manager syntax for
			# plugins. see :help nixCats.flake.outputs.categoryDefinitions.schemas below
			# for info
		optionalPlugins = with pkgs.vimPlugins; {
      general = [ ];
    };
    
    #<lspsAndRuntimeDeps>
    		# a flexible set of categories, each containing LSPs or
			# other internal runtime dependencies such as ctags or debuggers.
			# These are appended to the PATH (by default) while within
			# the Neovim program, including the Neovim terminal. 
		lspsAndRuntimeDeps = with pkgs; {
      general = [ ];
    };
		
		#<sharedLibraries>
			# a flexible set of categories, each containing a derivation for
			# a runtime shared library. Will be appended to the LD_LIBRARY_PATH variable. 
    sharedLibraries = with pkgs; {
      general = [ ];
    };
    
    #<environmentVariables>
    		# a flexible set of categories, each containing an ATTRIBUTE SET of 
			# EnvironmentVariableName = "EnvironmentVariableValue";
    environmentVariables = {
      test = {
        CATTESTVAR = "It worked!";
      };
    };
    
    #<wrapperArgs>
			# a flexible set of categories, each containing escaped lists of wrapper arguments.
			# see: https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
		wrapperArgs = {};
    
    #<extraWrapperArgs>
    		# a flexible set of categories, each containing unescaped wrapper arguments.
    extraWrapperArgs = {
      test = [
        '' --set CATTESTVAR2 "It worked again!"''
      ];
    };
    
    #<extraLuaPackages>
			# a flexible set of categories, each containing FUNCTIONS 
			# that return lists of extra Lua packages.
			# These functions are the same thing that you would pass to lua.withPackages.
			# Is used to populate $LUA_PATH and $LUA_CPATH 
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
        aliases = [ "vi" "vim" ];
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
	
in utils.baseBuilder luaPath { inherit nixpkgs; } categoryDefinitions packageDefinitions defaultPackageName
