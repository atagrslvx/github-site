#!/usr/bin/env bash
set -euo pipefail

# AG Veri Maskeleme Build Script
# macOS SwiftUI App Builder

echo "🚀 AG Veri Maskeleme Build Script"
echo "=================================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_NAME="AGVeriMaskeleme"
APP_NAME="AG Veri Maskeleme"
SCHEME="AGVeriMaskeleme"
BUILD_DIR="${PROJECT_DIR}/build"
ARCHIVE_PATH="${BUILD_DIR}/${PROJECT_NAME}.xcarchive"
EXPORT_PATH="${BUILD_DIR}/Release"
DMG_NAME="AG-Veri-Maskeleme.dmg"
DMG_PATH="${BUILD_DIR}/${DMG_NAME}"

# Parse arguments
BUILD_TYPE="${1:-release}"

echo -e "${BLUE}📁 Project Directory: ${PROJECT_DIR}${NC}"
echo -e "${BLUE}🔨 Build Type: ${BUILD_TYPE}${NC}"
echo ""

# Clean previous builds
if [ -d "$BUILD_DIR" ]; then
    echo -e "${YELLOW}🧹 Cleaning previous builds...${NC}"
    rm -rf "$BUILD_DIR"
fi

mkdir -p "$BUILD_DIR"

# Build app
echo -e "${BLUE}⚙️  Building ${APP_NAME}...${NC}"

if [ "$BUILD_TYPE" == "debug" ]; then
    # Debug build
    xcodebuild \
        -project "${PROJECT_DIR}/${PROJECT_NAME}.xcodeproj" \
        -scheme "$SCHEME" \
        -configuration Debug \
        -derivedDataPath "$BUILD_DIR" \
        clean build
    
    APP_PATH="${BUILD_DIR}/Build/Products/Debug/${APP_NAME}.app"
else
    # Release build with archive
    xcodebuild \
        -project "${PROJECT_DIR}/${PROJECT_NAME}.xcodeproj" \
        -scheme "$SCHEME" \
        -configuration Release \
        -archivePath "$ARCHIVE_PATH" \
        clean archive
    
    if [ ! -d "$ARCHIVE_PATH" ]; then
        echo -e "${RED}❌ Archive failed${NC}"
        exit 1
    fi
    
    # Export archive
    xcodebuild \
        -exportArchive \
        -archivePath "$ARCHIVE_PATH" \
        -exportPath "$EXPORT_PATH" \
        -exportOptionsPlist "${PROJECT_DIR}/ExportOptions.plist"
    
    APP_PATH="${EXPORT_PATH}/${APP_NAME}.app"
fi

# Verify app exists
if [ ! -d "$APP_PATH" ]; then
    echo -e "${RED}❌ Build failed - app not found at: ${APP_PATH}${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Build successful!${NC}"
echo -e "${BLUE}📦 App location: ${APP_PATH}${NC}"

# Code sign (ad-hoc)
echo ""
echo -e "${BLUE}🔐 Signing application...${NC}"
codesign --force --deep --sign - "$APP_PATH"
codesign --verify --deep --verbose "$APP_PATH"

echo -e "${GREEN}✅ Signing complete${NC}"

# Create DMG (Release only)
if [ "$BUILD_TYPE" == "release" ]; then
    echo ""
    echo -e "${BLUE}💾 Creating DMG installer...${NC}"
    
    # Remove old DMG
    [ -f "$DMG_PATH" ] && rm "$DMG_PATH"
    
    # Create temporary directory for DMG content
    TEMP_DMG_DIR="${BUILD_DIR}/dmg_temp"
    mkdir -p "$TEMP_DMG_DIR"
    
    # Copy app
    cp -R "$APP_PATH" "$TEMP_DMG_DIR/"
    
    # Create Applications symlink
    ln -s /Applications "$TEMP_DMG_DIR/Applications"
    
    # Create DMG
    hdiutil create \
        -volname "${APP_NAME}" \
        -srcfolder "$TEMP_DMG_DIR" \
        -ov \
        -format UDZO \
        "$DMG_PATH"
    
    # Clean up temp
    rm -rf "$TEMP_DMG_DIR"
    
    if [ -f "$DMG_PATH" ]; then
        echo -e "${GREEN}✅ DMG created successfully${NC}"
        echo -e "${BLUE}📦 DMG location: ${DMG_PATH}${NC}"
        
        # Calculate SHA-256
        echo ""
        echo -e "${BLUE}🔐 Calculating SHA-256...${NC}"
        SHA256=$(shasum -a 256 "$DMG_PATH" | awk '{print $1}')
        echo -e "${GREEN}SHA-256: ${SHA256}${NC}"
        
        # Save SHA to file
        echo "$SHA256" > "${DMG_PATH}.sha256"
        
        # File size
        FILE_SIZE=$(du -h "$DMG_PATH" | awk '{print $1}')
        echo -e "${BLUE}📊 File size: ${FILE_SIZE}${NC}"
    else
        echo -e "${RED}❌ DMG creation failed${NC}"
        exit 1
    fi
fi

echo ""
echo -e "${GREEN}=================================="
echo -e "✨ Build Complete!${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo -e "  1. Test the app: open '${APP_PATH}'"
if [ "$BUILD_TYPE" == "release" ]; then
    echo -e "  2. Mount DMG: open '${DMG_PATH}'"
    echo -e "  3. Move to public/downloads: cp '${DMG_PATH}' ../../public/downloads/"
    echo -e "  4. Update metadata: node ../../scripts/update-dmg.mjs '${DMG_PATH}'"
fi
echo ""
