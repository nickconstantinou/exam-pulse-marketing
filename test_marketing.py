#!/usr/bin/env python3
"""Tests for exam-pulse-marketing"""
import pytest
from pathlib import Path

SITE_DIR = Path(__file__).parent

def test_index_exists():
    """Test index.html exists"""
    assert (SITE_DIR / "index.html").exists()

def test_has_github_workflow():
    """Test GitHub Actions workflow exists"""
    assert (SITE_DIR / ".github").is_dir()

def test_has_gitignore():
    """Test .gitignore exists"""
    assert (SITE_DIR / ".gitignore").exists()

def test_has_blog():
    """Test blog directory exists"""
    assert (SITE_DIR / "blog").is_dir()

def test_robots_txt():
    """Test robots.txt exists"""
    assert (SITE_DIR / "robots.txt").exists()
