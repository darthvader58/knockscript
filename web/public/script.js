const codeEditor = document.getElementById('codeEditor');
const output = document.getElementById('output');
const runBtn = document.getElementById('runBtn');
const clearBtn = document.getElementById('clearBtn');
const clearOutputBtn = document.getElementById('clearOutputBtn');
const exampleSelector = document.getElementById('exampleSelector');

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
        runBtn.innerHTML = '▶ Run Code';
    }
});

clearBtn.addEventListener('click', () => {
    if (confirm('Are you sure you want to clear the editor?')) {
        codeEditor.value = '';
        codeEditor.focus();
    }
});

clearOutputBtn.addEventListener('click', () => {
    output.innerHTML = '<div class="output-placeholder">Run your code to see output here...</div>';
});

exampleSelector.addEventListener('change', (e) => {
    const exampleName = e.target.value;
    if (exampleName && examples[exampleName]) {
        codeEditor.value = examples[exampleName];
    }
    e.target.value = '';
});

function showOutput(text, success) {
    output.innerHTML = '';
    const outputDiv = document.createElement('div');
    outputDiv.className = success ? 'output-success' : 'output-error';
    outputDiv.textContent = text;
    output.appendChild(outputDiv);
}

//Keyboard shortcuts
codeEditor.addEventListener('keydown', (e) => {
    //run code
    if ((e.ctrlKey || e.metaKey) && e.key === 'Enter') {
        e.preventDefault();
        runBtn.click();
    }
    
    //indent with Tab
    if (e.key === 'Tab') {
        e.preventDefault();
        const start = codeEditor.selectionStart;
        const end = codeEditor.selectionEnd;
        const value = codeEditor.value;
        
        codeEditor.value = value.substring(0, start) + '    ' + value.substring(end);
        codeEditor.selectionStart = codeEditor.selectionEnd = start + 4;
    }
});

codeEditor.addEventListener('input', () => {
    localStorage.setItem('knockscript_code', codeEditor.value);
});

window.addEventListener('load', () => {
    const savedCode = localStorage.getItem('knockscript_code');
    if (savedCode) {
        codeEditor.value = savedCode;
    }
});