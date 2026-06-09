document.addEventListener('DOMContentLoaded', function() {
    // 1. Quantity Adjustments (Plus / Minus buttons)
    const qtyContainers = document.querySelectorAll('.quantity-control');
    qtyContainers.forEach(container => {
        const input = container.querySelector('input[type="number"]');
        const btnMinus = container.querySelector('.btn-minus');
        const btnPlus = container.querySelector('.btn-plus');
        const updateForm = container.closest('.quantity-update-form');

        if (input && btnMinus && btnPlus) {
            btnMinus.addEventListener('click', function() {
                let currentVal = parseInt(input.value) || 1;
                if (currentVal > 1) {
                    input.value = currentVal - 1;
                    if (updateForm) {
                        updateForm.submit();
                    }
                }
            });

            btnPlus.addEventListener('click', function() {
                let currentVal = parseInt(input.value) || 1;
                let maxStock = parseInt(input.getAttribute('max')) || 999;
                if (currentVal < maxStock) {
                    input.value = currentVal + 1;
                    if (updateForm) {
                        updateForm.submit();
                    }
                } else {
                    alert("Stock maximum atteint (" + maxStock + " disponible)");
                }
            });

            input.addEventListener('change', function() {
                let val = parseInt(input.value) || 1;
                let maxStock = parseInt(input.getAttribute('max')) || 999;
                if (val < 1) val = 1;
                if (val > maxStock) {
                    val = maxStock;
                    alert("Stock maximum atteint (" + maxStock + " disponible)");
                }
                input.value = val;
                if (updateForm) {
                    updateForm.submit();
                }
            });
        }
    });

    // 2. Deletion Confirmation Dialogs
    const deleteButtons = document.querySelectorAll('.confirm-delete');
    deleteButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            const itemType = this.getAttribute('data-type') || "cet élément";
            const confirmMsg = "Êtes-vous sûr de vouloir supprimer " + itemType + " ? Cette action est irréversible.";
            if (!confirm(confirmMsg)) {
                e.preventDefault();
            }
        });
    });

    // 3. Clear Cart Confirmation
    const clearCartBtn = document.querySelector('.confirm-clear-cart');
    if (clearCartBtn) {
        clearCartBtn.addEventListener('click', function(e) {
            if (!confirm("Voulez-vous vraiment vider votre panier ?")) {
                e.preventDefault();
            }
        });
    }

    // 4. Auto-dismiss alerts
    const alerts = document.querySelectorAll('.alert-dismissible-auto');
    alerts.forEach(alert => {
        setTimeout(() => {
            alert.style.transition = 'opacity 0.5s ease';
            alert.style.opacity = '0';
            setTimeout(() => {
                alert.remove();
            }, 500);
        }, 4000);
    });
});
