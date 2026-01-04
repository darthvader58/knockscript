// Smooth scrolling for anchor links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            target.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
            
            // Update active state in TOC
            updateActiveTOC(this.getAttribute('href'));
        }
    });
});

// Update active TOC item
function updateActiveTOC(hash) {
    document.querySelectorAll('.toc-item').forEach(item => {
        item.classList.remove('active');
        if (item.getAttribute('href') === hash) {
            item.classList.add('active');
        }
    });
}

// Highlight TOC based on scroll position
const observer = new IntersectionObserver(
    (entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const id = entry.target.getAttribute('id');
                if (id) {
                    updateActiveTOC('#' + id);
                }
            }
        });
    },
    {
        rootMargin: '-20% 0px -75% 0px'
    }
);

// Observe all sections
document.querySelectorAll('.docs-section[id]').forEach(section => {
    observer.observe(section);
});

// Copy code functionality
document.querySelectorAll('.copy-btn').forEach(button => {
    button.addEventListener('click', function() {
        const code = this.getAttribute('data-copy');
        
        // Create temporary textarea
        const textarea = document.createElement('textarea');
        textarea.value = code;
        textarea.style.position = 'fixed';
        textarea.style.opacity = '0';
        document.body.appendChild(textarea);
        
        // Select and copy
        textarea.select();
        try {
            document.execCommand('copy');
            
            // Update button text
            const originalText = this.textContent;
            this.textContent = 'Copied!';
            this.classList.add('copied');
            
            setTimeout(() => {
                this.textContent = originalText;
                this.classList.remove('copied');
            }, 2000);
        } catch (err) {
            console.error('Failed to copy:', err);
        }
        
        document.body.removeChild(textarea);
    });
});

// Add keyboard navigation
document.addEventListener('keydown', (e) => {
    // Navigate with arrow keys when TOC is focused
    if (document.activeElement.classList.contains('toc-item')) {
        const items = Array.from(document.querySelectorAll('.toc-item'));
        const currentIndex = items.indexOf(document.activeElement);
        
        if (e.key === 'ArrowDown' && currentIndex < items.length - 1) {
            e.preventDefault();
            items[currentIndex + 1].focus();
        } else if (e.key === 'ArrowUp' && currentIndex > 0) {
            e.preventDefault();
            items[currentIndex - 1].focus();
        }
    }
});

// Back to top functionality
let backToTopButton;

function createBackToTopButton() {
    backToTopButton = document.createElement('button');
    backToTopButton.innerHTML = `
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M18 15l-6-6-6 6"/>
        </svg>
    `;
    backToTopButton.className = 'back-to-top';
    backToTopButton.style.cssText = `
        position: fixed;
        bottom: 32px;
        right: 32px;
        width: 48px;
        height: 48px;
        border-radius: 50%;
        background: var(--primary-color);
        color: white;
        border: none;
        cursor: pointer;
        display: none;
        align-items: center;
        justify-content: center;
        box-shadow: var(--shadow-md);
        transition: all 0.3s;
        z-index: 1000;
    `;
    
    backToTopButton.addEventListener('click', () => {
        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        });
    });
    
    document.body.appendChild(backToTopButton);
}

// Show/hide back to top button
window.addEventListener('scroll', () => {
    if (!backToTopButton) {
        createBackToTopButton();
    }
    
    if (window.scrollY > 300) {
        backToTopButton.style.display = 'flex';
    } else {
        backToTopButton.style.display = 'none';
    }
});

// Add hover effect to back to top button
if (backToTopButton) {
    backToTopButton.addEventListener('mouseenter', () => {
        backToTopButton.style.transform = 'translateY(-2px)';
    });
    
    backToTopButton.addEventListener('mouseleave', () => {
        backToTopButton.style.transform = 'translateY(0)';
    });
}

// Initialize on page load
window.addEventListener('load', () => {
    // Set initial active TOC item based on URL hash
    if (window.location.hash) {
        updateActiveTOC(window.location.hash);
    } else {
        const firstTocItem = document.querySelector('.toc-item');
        if (firstTocItem) {
            firstTocItem.classList.add('active');
        }
    }
});