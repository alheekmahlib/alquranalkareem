#!/usr/bin/env python3
"""
Convert SVG files (hijri months + surah names) to Android VectorDrawable XML.
Usage: python3 convert_svg_to_android.py
"""

import os
import re
import xml.etree.ElementTree as ET

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
HIJRI_SVG_DIR = os.path.join(BASE_DIR, 'assets', 'svg', 'hijri')
SURAH_SVG_DIR = os.path.join(BASE_DIR, 'assets', 'svg', 'surah_name')
OUTPUT_DIR = os.path.join(BASE_DIR, 'android', 'app', 'src', 'main', 'res', 'drawable')

ANDROID_NS = 'http://schemas.android.com/apk/res/android'
SVG_NS = 'http://www.w3.org/2000/svg'

def extract_paths(element, parent_fill_rule=None):
    """Recursively extract all path data from SVG element."""
    paths = []
    ns = {'': SVG_NS}
    
    tag = element.tag.replace(f'{{{SVG_NS}}}', '')
    
    fill_rule = element.get('fill-rule', parent_fill_rule)
    
    if tag == 'path':
        d = element.get('d', '')
        if d:
            fr = element.get('fill-rule', parent_fill_rule)
            paths.append({'d': d, 'fill_rule': fr})
    
    for child in element:
        child_tag = child.tag.replace(f'{{{SVG_NS}}}', '')
        if child_tag in ('g', 'path', 'svg'):
            paths.extend(extract_paths(child, fill_rule))
    
    return paths


def svg_to_vector_drawable(svg_path, fill_color='#000000'):
    """Convert SVG file to Android VectorDrawable XML string."""
    ET.register_namespace('', SVG_NS)
    tree = ET.parse(svg_path)
    root = tree.getroot()
    
    viewbox = root.get('viewBox', '0 0 100 100')
    parts = viewbox.split()
    vp_width = parts[2]
    vp_height = parts[3]
    
    paths = extract_paths(root)
    
    if not paths:
        return None
    
    lines = []
    lines.append('<?xml version="1.0" encoding="utf-8"?>')
    lines.append(f'<vector xmlns:android="http://schemas.android.com/apk/res/android"')
    lines.append(f'    android:width="{vp_width}dp"')
    lines.append(f'    android:height="{vp_height}dp"')
    lines.append(f'    android:viewportWidth="{vp_width}"')
    lines.append(f'    android:viewportHeight="{vp_height}">')
    
    for p in paths:
        fill_type = ''
        if p.get('fill_rule') == 'evenodd':
            fill_type = '\n        android:fillType="evenOdd"'
        lines.append(f'    <path')
        lines.append(f'        android:fillColor="{fill_color}"{fill_type}')
        lines.append(f'        android:pathData="{p["d"]}"/>')
    
    lines.append('</vector>')
    return '\n'.join(lines)


def convert_hijri():
    """Convert hijri month SVGs (1.svg - 12.svg) → hijri_1.xml - hijri_12.xml"""
    count = 0
    for i in range(1, 13):
        svg_file = os.path.join(HIJRI_SVG_DIR, f'{i}.svg')
        if not os.path.exists(svg_file):
            print(f'  WARNING: {svg_file} not found')
            continue
        
        xml_content = svg_to_vector_drawable(svg_file)
        if xml_content:
            out_file = os.path.join(OUTPUT_DIR, f'hijri_{i}.xml')
            with open(out_file, 'w', encoding='utf-8') as f:
                f.write(xml_content)
            count += 1
    print(f'  Converted {count} hijri SVGs')


def convert_surah():
    """Convert surah name SVGs → surah_001.xml - surah_00114.xml"""
    count = 0
    for i in range(1, 115):
        # File naming: 001, 002, ..., 009, 0010, 0011, ..., 0099, 00100, ..., 00114
        # Pattern from actual files: 001, 002, ..., 009, 0010, ..., 0099, 00100, ..., 00114
        if i < 10:
            fname = f'00{i}'
        elif i < 100:
            fname = f'00{i}'
        else:
            fname = f'00{i}'
        
        svg_file = os.path.join(SURAH_SVG_DIR, f'{fname}.svg')
        if not os.path.exists(svg_file):
            print(f'  WARNING: {svg_file} not found')
            continue
        
        # Android drawable names: surah_001, surah_002, ..., surah_114
        # Use consistent 3-digit padding for resource names
        res_name = f'surah_{i:03d}'
        xml_content = svg_to_vector_drawable(svg_file)
        if xml_content:
            out_file = os.path.join(OUTPUT_DIR, f'{res_name}.xml')
            with open(out_file, 'w', encoding='utf-8') as f:
                f.write(xml_content)
            count += 1
    print(f'  Converted {count} surah SVGs')


def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    print('Converting hijri month SVGs...')
    convert_hijri()
    print('Converting surah name SVGs...')
    convert_surah()
    print('Done!')


if __name__ == '__main__':
    main()
