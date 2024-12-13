# 1 "test.tfcpp"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 418 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "test.tfcpp" 2
# 1 "././helperfunctions.h" 1
# 2 "test.tfcpp" 2

locals{
    x = 3
}

output "o" {
    value = local.x
}
