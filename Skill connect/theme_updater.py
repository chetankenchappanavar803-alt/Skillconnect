import os
import re

new_config = """    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    "colors": {
                        "primary": "#00d2ff",
                        "surface": "#0a0a0a",
                        "on-surface": "#ffffff",
                        "primary-container": "#02313a",
                        "on-primary-container": "#ffffff",
                        "surface-container": "#111111",
                        "surface-container-high": "#1a1a1a",
                        "surface-container-lowest": "#000000",
                        "surface-container-low": "#0d0d0d",
                        "on-surface-variant": "#a3a3a3",
                        "on-primary": "#000000"
                    }
                }
            }
        }
    </script>"""

html_files = ["chat.html", "hackathons.html", "profile.html", "search.html"]

for f in html_files:
    if not os.path.exists(f):
        continue
    with open(f, 'r', encoding='utf-8') as file:
        content = file.read()
    
    # regex replace tailwind-config block
    content = re.sub(r'<script id="tailwind-config">[\s\S]*?</script>', new_config, content)
    
    # replace hardcoded light classes
    content = content.replace('bg-slate-50/85', 'bg-[#0a0a0a]/85')
    content = content.replace('bg-white/80', 'bg-[#0a0a0a]/80')
    content = content.replace('text-indigo-800', 'text-primary')
    content = content.replace('text-indigo-700', 'text-primary')
    content = content.replace('border-indigo-700', 'border-primary')
    content = content.replace('text-slate-500', 'text-on-surface-variant')
    content = content.replace('text-slate-400', 'text-on-surface-variant')
    content = content.replace('border-slate-200/10', 'border-white/10')
    content = content.replace('bg-white', 'bg-surface-container')
    
    with open(f, 'w', encoding='utf-8') as file:
        file.write(content)

print("Updated HTML files to dark mode theme!")
