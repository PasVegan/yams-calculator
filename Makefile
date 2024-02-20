NAME = yams

ARCHIVE := zig-linux-x86_64-0.12.0-dev.2063+804cee3b9.tar.xz

EXPECTED_OUTPUTS := zig-linux-x86_64-0.12.0-dev.2063+804cee3b9/zig

# Default target
all: $(EXPECTED_OUTPUTS)
	@zig-linux-x86_64-0.12.0-dev.2063+804cee3b9/zig build -p . --prefix-exe-dir . -Doptimize=ReleaseSafe

debug: $(EXPECTED_OUTPUTS)
	@zig-linux-x86_64-0.12.0-dev.2063+804cee3b9/zig build -p . --prefix-exe-dir . -Doptimize=Debug

# Rule to check each expected output and extract the tar.gz if any are missing
$(EXPECTED_OUTPUTS):
	@if [ ! -e $@ ]; then \
	    echo "Extracting $(ARCHIVE)..."; \
	    tar -x --xz -f $(ARCHIVE); \
	fi

clean:
	@rm -rf zig-cache

fclean: clean
	@find . -name $(NAME) -delete
	@echo "Cleaning up..."
	@rm -rf $(EXPECTED_OUTPUTS)

re:	fclean all


.PHONY: all debug clean fclean re
