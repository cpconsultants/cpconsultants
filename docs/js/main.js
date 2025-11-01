// Modern JavaScript for CPC Theme
(function($) {
    'use strict';
    
    // Slideshow functionality for hero section
    function slideSwitch() {
        var $active = $('.hero-slideshow img.active');
        if ($active.length == 0) {
            $active = $('.hero-slideshow img:last');
        }
        var $next = $active.next().length ? $active.next() : $('.hero-slideshow img:first');
        
        $active.removeClass('active');
        $next.addClass('active');
    }
    
    // Initialize slideshow
    $(document).ready(function() {
        if ($('.hero-slideshow img').length > 0) {
            setInterval(slideSwitch, 5000);
        }
    });
    
    // Smooth scrolling for anchor links
    $('a[href^="#"]').on('click', function(event) {
        var target = $(this.getAttribute('href'));
        if (target.length) {
            event.preventDefault();
            $('html, body').stop().animate({
                scrollTop: target.offset().top - 100
            }, 800, 'swing');
        }
    });

    // Intersection Observer for scroll animations
    if ('IntersectionObserver' in window) {
        var observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };

        var observer = new IntersectionObserver(function(entries) {
            entries.forEach(function(entry) {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                    observer.unobserve(entry.target);
                }
            });
        }, observerOptions);

        // Observe elements on page load for scroll-triggered animations
        $(document).ready(function() {
            setTimeout(function() {
                $('.feature-box, .service-card, .service-box, .expert-card, .contact-box, .intro-box').each(function() {
                    var $el = $(this);
                    // Only add scroll animation if element doesn't have CSS animation
                    if (!$el.css('animation') || $el.css('animation') === 'none') {
                        observer.observe(this);
                    }
                });
            }, 100);
        });
    }
    
    // Form submission handler
    $('#enquiry-form').on('submit', function(e) {
        e.preventDefault();
        
        var $form = $(this);
        var $submitBtn = $('#submit-btn');
        var $btnText = $submitBtn.find('.btn-text');
        var $btnLoading = $submitBtn.find('.btn-loading');
        var $formMessage = $('#form-message');
        
        // Hide any previous messages
        $formMessage.hide().removeClass('form-success form-error').html('');
        
        // Validate form
        if (!validateForm($form)) {
            return false;
        }
        
        // Show loading state
        $btnText.hide();
        $btnLoading.show();
        $submitBtn.prop('disabled', true);
        
        // Collect form data
        var formData = {
            name: $('#full_name').val().trim(),
            company: $('#company').val().trim(),
            email: $('#email').val().trim(),
            phone: $('#phone').val().trim(),
            country: $('#country').val().trim(),
            service: $('#service_interest').val().trim(),
            project: $('#project_description').val().trim(),
            timeline: $('#timeline').val().trim(),
            additional: $('#additional_info').val().trim()
        };
        
        // Format email body
        var emailBody = 'New Pharmaceutical Consulting Enquiry from ' + formData.name + '\n\n';
        emailBody += 'Contact Information:\n';
        emailBody += 'Name: ' + formData.name + '\n';
        emailBody += 'Company: ' + formData.company + '\n';
        emailBody += 'Email: ' + formData.email + '\n';
        emailBody += 'Phone: ' + formData.phone + '\n';
        emailBody += 'Country: ' + formData.country + '\n\n';
        emailBody += 'Service Interest: ' + formData.service + '\n';
        emailBody += 'Expected Timeline: ' + (formData.timeline || 'Not specified') + '\n\n';
        emailBody += 'Project Description:\n' + formData.project + '\n\n';
        if (formData.additional) {
            emailBody += 'Additional Information:\n' + formData.additional + '\n';
        }
        
        // Create mailto link with both recipient emails
        var subject = encodeURIComponent('Pharmaceutical Consulting Enquiry - ' + formData.company);
        var body = encodeURIComponent(emailBody);
        // Multiple recipients separated by comma
        var recipients = 'venkatcpc@gmail.com,projectsvenkat@gmail.com';
        var mailtoLink = 'mailto:' + recipients + '?subject=' + subject + '&body=' + body;
        
        // Open mailto with both email addresses
        window.location.href = mailtoLink;
        
        // Show success message
        setTimeout(function() {
            $btnText.show();
            $btnLoading.hide();
            $submitBtn.prop('disabled', false);
            
            $formMessage
                .html('<i class="fas fa-check-circle"></i> Thank you! Your email client should open with your enquiry addressed to both <a href="mailto:venkatcpc@gmail.com">venkatcpc@gmail.com</a> and <a href="mailto:projectsvenkat@gmail.com">projectsvenkat@gmail.com</a>. If it doesn\'t open, please email us directly.')
                .addClass('form-success')
                .show();
            
            // Reset form after showing message
            setTimeout(function() {
                $form[0].reset();
                $formMessage.fadeOut();
            }, 5000);
        }, 500);
        
        return false;
    });
    
    function validateForm($form) {
        var isValid = true;
        var errors = [];
        
        // Check required fields
        $form.find('[required]').each(function() {
            var $field = $(this);
            var value = $field.val().trim();
            
            if (!value) {
                isValid = false;
                $field.addClass('field-error');
                errors.push($field.closest('.form-group').find('label').text().replace('*', '').trim() + ' is required');
            } else {
                $field.removeClass('field-error');
            }
            
            // Validate email
            if ($field.attr('type') === 'email' && value && !isValidEmail(value)) {
                isValid = false;
                $field.addClass('field-error');
                errors.push('Please enter a valid email address');
            }
        });
        
        if (!isValid) {
            var $formMessage = $('#form-message');
            $formMessage
                .html('<i class="fas fa-exclamation-circle"></i> ' + errors.join('<br>'))
                .addClass('form-error')
                .show();
        }
        
        return isValid;
    }
    
    function isValidEmail(email) {
        var re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return re.test(email);
    }
    
})(jQuery);

