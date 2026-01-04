const codeEditor = document.getElementById('codeEditor');
const output = document.getElementById('output');
const runBtn = document.getElementById('runBtn');
const clearBtn = document.getElementById('clearBtn');
const clearOutputBtn = document.getElementById('clearOutputBtn');

// View Management
const views = {
    console: document.getElementById('consoleView'),
    examples: document.getElementById('examplesView'),
    reference: document.getElementById('referenceView')
};

const sidebarItems = document.querySelectorAll('.sidebar-item');

// Code Examples - DEFINE THIS FIRST
const examples = {
    hello_world: `Knock knock
Who's there?
Print
Print who? "Hello, World!"`,
    
    arithmetic: `Knock knock
Who's there?
Set
Set who? x to 10

Knock knock
Who's there?
Set
Set who? y to 5

Knock knock
Who's there?
Set
Set who? result to x plus y times 2

Knock knock
Who's there?
Print
Print who? "Result: "

Knock knock
Who's there?
Print
Print who? result`,
    
    loops: `Knock knock
Who's there?
Set
Set who? counter to 1

Knock knock
Who's there?
While
While who? counter less than 6
    Knock knock
    Who's there?
    Print
    Print who? counter
    
    Knock knock
    Who's there?
    Set
    Set who? counter to counter plus 1
Done

Knock knock
Who's there?
Print
Print who? "Done!"`,
    
    classes: `Knock knock
Who's there?
Class
Class who? Person with name and age

Knock knock
Who's there?
Method
Method who? greet for Person
    Knock knock
    Who's there?
    Print
    Print who? "Hello, I'm "
    
    Knock knock
    Who's there?
    Print
    Print who? name
Done

Knock knock
Who's there?
Set
Set who? alice to new Person with name "Alice" and age 30

Knock knock
Who's there?
Call
Call who? greet on alice`
};

// Sidebar navigation
sidebarItems.forEach((item, index) => {
    item.addEventListener('click', () => {
        // Remove active class from all items
        sidebarItems.forEach(i => i.classList.remove('active'));
        // Add active to clicked item
        item.classList.add('active');
        
        // Hide all views
        Object.values(views).forEach(view => view.classList.remove('active'));
        
        // Show appropriate view
        if (index === 0) {
            views.console.classList.add('active');
        } else if (index === 1) {
            views.examples.classList.add('active');
        } else if (index === 2) {
            views.reference.classList.add('active');
        }
        
        // Scroll to top of content area
        window.scrollTo({ top: 0, behavior: 'smooth' });
    });
});

// Example card click handlers - NOW examples is already defined
const exampleCards = document.querySelectorAll('.example-card');
console.log('Found example cards:', exampleCards.length);

exampleCards.forEach(card => {
    card.addEventListener('click', () => {
        console.log('Example card clicked!');
        const exampleName = card.getAttribute('data-example');
        console.log('Loading example:', exampleName);
        
        if (examples[exampleName]) {
            console.log('Example found, loading code...');
            // Load the example code
            codeEditor.value = examples[exampleName];
            
            // Switch to console view
            sidebarItems.forEach(i => i.classList.remove('active'));
            sidebarItems[0].classList.add('active'); // Console is first item
            Object.values(views).forEach(view => view.classList.remove('active'));
            views.console.classList.add('active');
            
            // Focus editor and scroll to top
            codeEditor.focus();
            window.scrollTo({ top: 0, behavior: 'smooth' });
            
            console.log('Example loaded successfully!');
        } else {
            console.log('Example not found:', exampleName);
        }
    });
});

// Run Code
runBtn.addEventListener('click', async () => {
    const code = codeEditor.value;
    
    if (!code.trim()) {
        showOutput('Please enter some code first!', false);
        return;
    }
    
    // Show loading
    runBtn.disabled = true;
    runBtn.innerHTML = '<span class="loading"></span> Running...';
    
    try {
        const response = await fetch('/compile', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ code })
        });
        
        const result = await response.json();
        
        if (result.success) {
            showOutput(result.output || '(No output)', true);
        } else {
            showOutput('Error: ' + result.error, false);
        }
    } catch (error) {
        showOutput('Network Error: ' + error.message, false);
    } finally {
        runBtn.disabled = false;
        runBtn.innerHTML = `
            <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
                <path d="M8 5v14l11-7z"/>
            </svg>
            Run
        `;
    }
});

// Clear Editor
clearBtn.addEventListener('click', () => {
    if (confirm('Are you sure you want to clear the editor?')) {
        codeEditor.value = '';
        codeEditor.focus();
    }
});

// Clear Output
clearOutputBtn.addEventListener('click', () => {
    output.innerHTML = `
        <div class="output-placeholder">
            <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                <polyline points="16 18 22 12 16 6"/>
                <polyline points="8 6 2 12 8 18"/>
            </svg>
            <p>Run your code to see output</p>
        </div>
    `;
});

// Show Output Helper
function showOutput(text, success) {
    output.innerHTML = '';
    const outputDiv = document.createElement('div');
    outputDiv.className = success ? 'output-success' : 'output-error';
    outputDiv.textContent = text;
    output.appendChild(outputDiv);
}

// Keyboard Shortcuts
codeEditor.addEventListener('keydown', (e) => {
    // Cmd/Ctrl + Enter to run code
    if ((e.ctrlKey || e.metaKey) && e.key === 'Enter') {
        e.preventDefault();
        runBtn.click();
    }
    
    // Tab for indentation
    if (e.key === 'Tab') {
        e.preventDefault();
        const start = codeEditor.selectionStart;
        const end = codeEditor.selectionEnd;
        const value = codeEditor.value;
        
        codeEditor.value = value.substring(0, start) + '    ' + value.substring(end);
        codeEditor.selectionStart = codeEditor.selectionEnd = start + 4;
    }
});

// Auto-save to localStorage
codeEditor.addEventListener('input', () => {
    localStorage.setItem('knockscript_code', codeEditor.value);
});

// Load saved code on page load
window.addEventListener('load', () => {
    const savedCode = localStorage.getItem('knockscript_code');
    if (savedCode) {
        codeEditor.value = savedCode;
    }
});

// Add smooth scroll behavior
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            target.scrollIntoView({
                behavior: 'smooth'
            });
        }
    });
});