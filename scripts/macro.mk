###################
# MAKEFILE MACROS #
###################

define check_defined
	$(if $(value $1),,$(error '$1' is not defined))
endef
