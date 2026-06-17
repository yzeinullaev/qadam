#!/usr/bin/env python3
"""Generate Qadam.xcodeproj for native iOS app."""

import uuid
from pathlib import Path

ROOT = Path(__file__).resolve().parent
PROJECT_NAME = "Qadam"
BUNDLE_ID = "com.qadam.qadam.native"
TEAM_ID = "W86PS7HC34"


def uid():
    return uuid.uuid4().hex[:24].upper()


swift_files = sorted((ROOT / "Qadam").rglob("*.swift"))
info_plist = ROOT / "Qadam" / "Info.plist"
assets_catalog = ROOT / "Qadam" / "Assets.xcassets"

project_id = uid()
target_id = uid()
sources_phase_id = uid()
frameworks_phase_id = uid()
resources_phase_id = uid()
project_config_list = uid()
target_config_list = uid()
debug_config_id = uid()
release_config_id = uid()
target_debug_id = uid()
target_release_id = uid()
product_ref = uid()
adhan_product_dep = uid()
adhan_package_ref = uid()
app_product = uid()
main_group = uid()
qadam_group = uid()
products_group = uid()

file_refs = {}
build_files = {}

for sf in swift_files:
    rel = sf.relative_to(ROOT).as_posix()
    fid = uid()
    bid = uid()
    file_refs[rel] = (fid, sf.name, rel)
    build_files[rel] = bid

info_rel = info_plist.relative_to(ROOT).as_posix()
info_id = uid()
file_refs[info_rel] = (info_id, "Info.plist", info_rel)

assets_rel = assets_catalog.relative_to(ROOT).as_posix()
assets_id = uid()
assets_build_id = uid()
file_refs[assets_rel] = (assets_id, "Assets.xcassets", assets_rel)

lines = []
lines.append("// !$*UTF8*$!")
lines.append("{")
lines.append("\tarchiveVersion = 1;")
lines.append("\tclasses = {};")
lines.append("\tobjectVersion = 56;")
lines.append("\tobjects = {")

lines.append("\n/* Begin PBXBuildFile section */")
for rel, bid in build_files.items():
    fid, name, _ = file_refs[rel]
    lines.append(f"\t\t{bid} /* {name} in Sources */ = {{isa = PBXBuildFile; fileRef = {fid} /* {name} */; }};")
lines.append(f"\t\t{adhan_product_dep} /* Adhan in Frameworks */ = {{isa = PBXBuildFile; productRef = {product_ref} /* Adhan */; }};")
lines.append(f"\t\t{assets_build_id} /* Assets.xcassets in Resources */ = {{isa = PBXBuildFile; fileRef = {assets_id} /* Assets.xcassets */; }};")
lines.append("/* End PBXBuildFile section */")

lines.append("\n/* Begin PBXFileReference section */")
lines.append(
    f"\t\t{app_product} /* {PROJECT_NAME}.app */ = {{isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = {PROJECT_NAME}.app; sourceTree = BUILT_PRODUCTS_DIR; }};"
)
for rel, (fid, name, path) in file_refs.items():
    if name.endswith(".swift"):
        lines.append(
            f"\t\t{fid} /* {name} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = {path}; sourceTree = \"<group>\"; }};"
        )
    elif name.endswith(".xcassets"):
        lines.append(
            f"\t\t{fid} /* {name} */ = {{isa = PBXFileReference; lastKnownFileType = folder.assetcatalog; path = {path}; sourceTree = \"<group>\"; }};"
        )
    else:
        lines.append(
            f"\t\t{fid} /* Info.plist */ = {{isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = {path}; sourceTree = \"<group>\"; }};"
        )
lines.append("/* End PBXFileReference section */")

lines.append("\n/* Begin PBXFrameworksBuildPhase section */")
lines.append(f"\t\t{frameworks_phase_id} /* Frameworks */ = {{")
lines.append("\t\t\tisa = PBXFrameworksBuildPhase;")
lines.append("\t\t\tbuildActionMask = 2147483647;")
lines.append("\t\t\tfiles = (")
lines.append(f"\t\t\t\t{adhan_product_dep} /* Adhan in Frameworks */,")
lines.append("\t\t\t);")
lines.append("\t\t\trunOnlyForDeploymentPostprocessing = 0;")
lines.append("\t\t};")
lines.append("/* End PBXFrameworksBuildPhase section */")

lines.append("\n/* Begin PBXGroup section */")
lines.append(f"\t\t{products_group} /* Products */ = {{")
lines.append("\t\t\tisa = PBXGroup;")
lines.append("\t\t\tchildren = (")
lines.append(f"\t\t\t\t{app_product} /* {PROJECT_NAME}.app */,")
lines.append("\t\t\t);")
lines.append("\t\t\tname = Products;")
lines.append("\t\t\tsourceTree = \"<group>\";")
lines.append("\t\t};")

lines.append(f"\t\t{qadam_group} /* Qadam */ = {{")
lines.append("\t\t\tisa = PBXGroup;")
lines.append("\t\t\tchildren = (")
for rel in sorted(file_refs.keys()):
    fid = file_refs[rel][0]
    name = file_refs[rel][1]
    lines.append(f"\t\t\t\t{fid} /* {name} */,")
lines.append("\t\t\t);")
lines.append("\t\t\tname = Qadam;")
lines.append("\t\t\tsourceTree = \"<group>\";")
lines.append("\t\t};")

lines.append(f"\t\t{main_group} = {{")
lines.append("\t\t\tisa = PBXGroup;")
lines.append("\t\t\tchildren = (")
lines.append(f"\t\t\t\t{qadam_group} /* Qadam */,")
lines.append(f"\t\t\t\t{products_group} /* Products */,")
lines.append("\t\t\t);")
lines.append("\t\t\tsourceTree = \"<group>\";")
lines.append("\t\t};")
lines.append("/* End PBXGroup section */")

lines.append("\n/* Begin PBXNativeTarget section */")
lines.append(f"\t\t{target_id} /* {PROJECT_NAME} */ = {{")
lines.append("\t\t\tisa = PBXNativeTarget;")
lines.append(f"\t\t\tbuildConfigurationList = {target_config_list};")
lines.append("\t\t\tbuildPhases = (")
lines.append(f"\t\t\t\t{sources_phase_id} /* Sources */,")
lines.append(f"\t\t\t\t{frameworks_phase_id} /* Frameworks */,")
lines.append(f"\t\t\t\t{resources_phase_id} /* Resources */,")
lines.append("\t\t\t);")
lines.append("\t\t\tbuildRules = ();")
lines.append("\t\t\tdependencies = ();")
lines.append(f"\t\t\tname = {PROJECT_NAME};")
lines.append(f"\t\t\tpackageProductDependencies = ({product_ref} /* Adhan */);")
lines.append(f"\t\t\tproductName = {PROJECT_NAME};")
lines.append(f"\t\t\tproductReference = {app_product};")
lines.append('\t\t\tproductType = "com.apple.product-type.application";')
lines.append("\t\t};")
lines.append("/* End PBXNativeTarget section */")

lines.append("\n/* Begin PBXProject section */")
lines.append(f"\t\t{project_id} /* Project object */ = {{")
lines.append("\t\t\tisa = PBXProject;")
lines.append("\t\t\tattributes = {")
lines.append("\t\t\t\tBuildIndependentTargetsInParallel = 1;")
lines.append("\t\t\t\tLastSwiftUpdateCheck = 1500;")
lines.append("\t\t\t\tLastUpgradeCheck = 1500;")
lines.append("\t\t\t};")
lines.append(f"\t\t\tbuildConfigurationList = {project_config_list};")
lines.append('\t\t\tcompatibilityVersion = "Xcode 14.0";')
lines.append("\t\t\tdevelopmentRegion = ru;")
lines.append("\t\t\thasScannedForEncodings = 0;")
lines.append("\t\t\tknownRegions = (ru, Base);")
lines.append(f"\t\t\tmainGroup = {main_group};")
lines.append(f"\t\t\tpackageReferences = ({adhan_package_ref} /* adhan-swift */);")
lines.append(f"\t\t\tproductRefGroup = {products_group};")
lines.append('\t\t\tprojectDirPath = "";')
lines.append('\t\t\tprojectRoot = "";')
lines.append(f"\t\t\ttargets = ({target_id});")
lines.append("\t\t};")
lines.append("/* End PBXProject section */")

lines.append("\n/* Begin PBXResourcesBuildPhase section */")
lines.append(f"\t\t{resources_phase_id} /* Resources */ = {{")
lines.append("\t\t\tisa = PBXResourcesBuildPhase;")
lines.append("\t\t\tbuildActionMask = 2147483647;")
lines.append("\t\t\tfiles = (")
lines.append(f"\t\t\t\t{assets_build_id} /* Assets.xcassets in Resources */,")
lines.append("\t\t\t);")
lines.append("\t\t\trunOnlyForDeploymentPostprocessing = 0;")
lines.append("\t\t};")
lines.append("/* End PBXResourcesBuildPhase section */")

lines.append("\n/* Begin PBXSourcesBuildPhase section */")
lines.append(f"\t\t{sources_phase_id} /* Sources */ = {{")
lines.append("\t\t\tisa = PBXSourcesBuildPhase;")
lines.append("\t\t\tbuildActionMask = 2147483647;")
lines.append("\t\t\tfiles = (")
for rel, bid in build_files.items():
    name = file_refs[rel][1]
    lines.append(f"\t\t\t\t{bid} /* {name} in Sources */,")
lines.append("\t\t\t);")
lines.append("\t\t\trunOnlyForDeploymentPostprocessing = 0;")
lines.append("\t\t};")
lines.append("/* End PBXSourcesBuildPhase section */")

target_settings = f"""
\t\t\t\tASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
\t\t\t\tCODE_SIGN_STYLE = Automatic;
\t\t\t\tCURRENT_PROJECT_VERSION = 1;
\t\t\t\tDEVELOPMENT_TEAM = {TEAM_ID};
\t\t\t\tGENERATE_INFOPLIST_FILE = NO;
\t\t\t\tINFOPLIST_FILE = Qadam/Info.plist;
\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 16.0;
\t\t\t\tLD_RUNPATH_SEARCH_PATHS = ("$(inherited)", "@executable_path/Frameworks");
\t\t\t\tMARKETING_VERSION = 1.0;
\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = {BUNDLE_ID};
\t\t\t\tPRODUCT_NAME = "$(TARGET_NAME)";
\t\t\t\tSWIFT_VERSION = 5.0;
\t\t\t\tTARGETED_DEVICE_FAMILY = 1;"""

lines.append("\n/* Begin XCBuildConfiguration section */")
lines.append(f"\t\t{debug_config_id} /* Debug */ = {{")
lines.append("\t\t\tisa = XCBuildConfiguration;")
lines.append("\t\t\tbuildSettings = {")
lines.append("\t\t\t\tALWAYS_SEARCH_USER_PATHS = NO;")
lines.append("\t\t\t\tCLANG_ENABLE_MODULES = YES;")
lines.append("\t\t\t\tCOPY_PHASE_STRIP = NO;")
lines.append("\t\t\t\tDEBUG_INFORMATION_FORMAT = dwarf;")
lines.append("\t\t\t\tENABLE_TESTABILITY = YES;")
lines.append("\t\t\t\tGCC_OPTIMIZATION_LEVEL = 0;")
lines.append("\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 16.0;")
lines.append("\t\t\t\tONLY_ACTIVE_ARCH = YES;")
lines.append("\t\t\t\tSDKROOT = iphoneos;")
lines.append('\t\t\t\tSWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG;')
lines.append('\t\t\t\tSWIFT_OPTIMIZATION_LEVEL = "-Onone";')
lines.append("\t\t\t};")
lines.append("\t\t\tname = Debug;")
lines.append("\t\t};")

lines.append(f"\t\t{release_config_id} /* Release */ = {{")
lines.append("\t\t\tisa = XCBuildConfiguration;")
lines.append("\t\t\tbuildSettings = {")
lines.append("\t\t\t\tALWAYS_SEARCH_USER_PATHS = NO;")
lines.append("\t\t\t\tCLANG_ENABLE_MODULES = YES;")
lines.append("\t\t\t\tCOPY_PHASE_STRIP = NO;")
lines.append('\t\t\t\tDEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";')
lines.append("\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 16.0;")
lines.append("\t\t\t\tSDKROOT = iphoneos;")
lines.append("\t\t\t\tSWIFT_COMPILATION_MODE = wholemodule;")
lines.append("\t\t\t\tVALIDATE_PRODUCT = YES;")
lines.append("\t\t\t};")
lines.append("\t\t\tname = Release;")
lines.append("\t\t};")

for tid, tname in [(target_debug_id, "Debug"), (target_release_id, "Release")]:
    lines.append(f"\t\t{tid} /* {tname} */ = {{")
    lines.append("\t\t\tisa = XCBuildConfiguration;")
    lines.append("\t\t\tbuildSettings = {")
    lines.append(target_settings)
    lines.append("\t\t\t};")
    lines.append(f"\t\t\tname = {tname};")
    lines.append("\t\t};")
lines.append("/* End XCBuildConfiguration section */")

lines.append("\n/* Begin XCConfigurationList section */")
lines.append(f"\t\t{project_config_list} = {{")
lines.append("\t\t\tisa = XCConfigurationList;")
lines.append(f"\t\t\tbuildConfigurations = ({debug_config_id}, {release_config_id});")
lines.append("\t\t\tdefaultConfigurationIsVisible = 0;")
lines.append("\t\t\tdefaultConfigurationName = Release;")
lines.append("\t\t};")
lines.append(f"\t\t{target_config_list} = {{")
lines.append("\t\t\tisa = XCConfigurationList;")
lines.append(f"\t\t\tbuildConfigurations = ({target_debug_id}, {target_release_id});")
lines.append("\t\t\tdefaultConfigurationIsVisible = 0;")
lines.append("\t\t\tdefaultConfigurationName = Release;")
lines.append("\t\t};")
lines.append("/* End XCConfigurationList section */")

lines.append("\n/* Begin XCRemoteSwiftPackageReference section */")
lines.append(f"\t\t{adhan_package_ref} = {{")
lines.append("\t\t\tisa = XCRemoteSwiftPackageReference;")
lines.append('\t\t\trepositoryURL = "https://github.com/batoulapps/adhan-swift";')
lines.append("\t\t\trequirement = {")
lines.append("\t\t\t\tkind = upToNextMajorVersion;")
lines.append("\t\t\t\tminimumVersion = 1.4.0;")
lines.append("\t\t\t};")
lines.append("\t\t};")
lines.append("/* End XCRemoteSwiftPackageReference section */")

lines.append("\n/* Begin XCSwiftPackageProductDependency section */")
lines.append(f"\t\t{product_ref} /* Adhan */ = {{")
lines.append("\t\t\tisa = XCSwiftPackageProductDependency;")
lines.append(f"\t\t\tpackage = {adhan_package_ref};")
lines.append("\t\t\tproductName = Adhan;")
lines.append("\t\t};")
lines.append("/* End XCSwiftPackageProductDependency section */")

lines.append("\t};")
lines.append(f"\trootObject = {project_id};")
lines.append("}")

out_dir = ROOT / f"{PROJECT_NAME}.xcodeproj"
out_dir.mkdir(exist_ok=True)
(out_dir / "project.pbxproj").write_text("\n".join(lines) + "\n")
print(f"Generated {out_dir / 'project.pbxproj'} ({len(swift_files)} swift files)")
