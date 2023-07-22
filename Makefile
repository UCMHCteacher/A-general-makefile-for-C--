# NOTICE: You must add -I ./makefileSource when using this makefile

# INCLUDES
include OSDependentVariables.mf
include Functions.mf




# MakeFile Variables
MakeFileSourceDir = ./makefileSource
MainSourceDir2MFSrcDir = $(call now2root,$(MainSourceDir))$(MakeFileSourceDir)




# COMMANDS



# Command 1 "make" : make the final target file
# every source file ``$(MainSourceDir)/**.cpp`` is compiled to an object file ``$(ReleaseObjDir)/**.o``
# then object files are linked to generate $(ReleaseBinDir)/$(ReleaseBinName)

# computed variables
ReleaseObjDir = $(ReleaseDir)/obj
ReleaseBinDir = $(ReleaseDir)/bin

ReleaseSrcs = $(shell $(MakeBin) -s -C $(MainSourceDir) -f $(MainSourceDir2MFSrcDir)/SubDirMakeFile -I $(MainSourceDir2MFSrcDir) NowDir=$(MainSourceDir) NowDir2MFSrcDir=$(MainSourceDir2MFSrcDir))
ReleaseObjs = $(patsubst $(SourcePattern),$(ReleaseObjDir)/%.o,$(subst $(MainSourceDir)/,,$(ReleaseSrcs)))
ReleaseObjDirs = $(dir $(ReleaseObjs))
ReleaseBin = $(ReleaseBinDir)/$(ReleaseBinName)

# instructions
all: ReleaseEnv $(ReleaseObjDirs) $(ReleaseBin)

$(ReleaseBin): $(ReleaseObjs)
ifeq ($(ReleaseType),exe)
	$(CC) $(ReleaseObjs) -o $(ReleaseBin) $(CFlags)
endif
ifeq ($(ReleaseType),lib)
	$(LibCC) $(LibFlags) $(ReleaseBin) $(ReleaseObjs)
endif

$(ReleaseObjs): $(ReleaseObjDir)/%.o: $(MainSourceDir)/%.cpp
	$(CC) -c $< -o $@ $(CFlags)

$(ReleaseObjDirs):
	$(call MkIfNExist,$@)

ReleaseEnv:
	$(call MkIfNExist,$(ReleaseDir))
	$(call MkIfNExist,$(ReleaseBinDir))
	$(call MkIfNExist,$(ReleaseObjDir))




# Command 2 "make clean"

# editable variables
# you can add your target to this list
CleanList = CleanReleaseBin CleanReleaseObj CleanRelease CleanLibTest CleanUnitTest

# fake target
.PHONY: clean
.PHONY: $(CleanList)

# instructions
clean: $(CleanList)

CleanRelease:
	$(call RmIfExist,$(ReleaseDir))

CleanReleaseBin:
	$(call RmIfExist,$(ReleaseBinDir))

CleanReleaseObj:
	$(call RmIfExist,$(ReleaseObjDir))





# EX-Includes
# you can add your makefile in ./makefileSource
include Debug.mf
include UnitTest.mf
include LibTest.mf