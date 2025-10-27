#!/bin/bash
# verify-repo.sh - Check if all required files are present

echo "=========================================="
echo "KnockScript Repository Verification"
echo "=========================================="
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

missing=0
present=0

check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓${NC} $1"
        ((present++))
        return 0
    else
        echo -e "${RED}✗${NC} $1 ${RED}(MISSING)${NC}"
        ((missing++))
        return 1
    fi
}

check_dir() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}✓${NC} $1/"
        ((present++))
        return 0
    else
        echo -e "${RED}✗${NC} $1/ ${RED}(MISSING)${NC}"
        ((missing++))
        return 1
    fi
}

echo "Checking deployment files..."
echo "----------------------------"
check_file "Dockerfile"
check_file ".dockerignore"
check_file "railway.toml"
check_file "config.ru"
check_file "Gemfile"
check_file "Gemfile.lock"
check_file "start.sh"
echo ""

echo "Checking configuration..."
echo "------------------------"
check_dir "config"
check_file "config/puma.rb"
echo ""

echo "Checking core Ruby files..."
echo "--------------------------"
check_file "knockscript.rb"
check_file "lexer.rb"
check_file "parser.rb"
check_file "interpreter.rb"
check_file "ast_nodes.rb"
check_file "environment.rb"
check_file "token.rb"
echo ""

echo "Checking web application..."
echo "--------------------------"
check_dir "web"
check_file "web/app.rb"
check_dir "web/public"
check_file "web/public/index.html"
check_file "web/public/styles.css"
check_file "web/public/script.js"
echo ""

echo "Checking examples..."
echo "-------------------"
check_dir "examples"
check_file "examples/hello_world.ks"
check_file "examples/classes.ks"
echo ""

echo "=========================================="
echo "Summary:"
echo "=========================================="
echo -e "Files present: ${GREEN}$present${NC}"
echo -e "Files missing: ${RED}$missing${NC}"
echo ""

if [ $missing -eq 0 ]; then
    echo -e "${GREEN}✓ All required files are present!${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Make sure start.sh is executable: chmod +x start.sh"
    echo "2. Commit all files: git add . && git commit -m 'Add all files'"
    echo "3. Push to GitHub: git push"
    echo "4. Deploy on Railway"
    exit 0
else
    echo -e "${RED}✗ Some files are missing!${NC}"
    echo ""
    echo "Please add the missing files before deploying."
    echo ""
    echo "Critical files needed:"
    echo "  - All .rb files (Ruby source code)"
    echo "  - Gemfile.lock (run: bundle install)"
    echo "  - web/public/ files (HTML, CSS, JS)"
    echo "  - Deployment config (Dockerfile, railway.toml, etc.)"
    exit 1
fi