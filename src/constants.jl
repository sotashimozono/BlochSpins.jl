# --- Pauli Operators ---
const σ0 = Operator(@SMatrix [1.0+0im 0.0; 0.0 1.0])
const σx = Operator(@SMatrix [0.0+0im 1.0; 1.0 0.0])
const σy = Operator(@SMatrix [0.0 -1.0im; 1.0im 0.0])
const σz = Operator(@SMatrix [1.0+0im 0.0; 0.0 -1.0])
const σ  = SVector(σx, σy, σz)

# --- Computational Basis (Z-basis) ---
const k_up   = Ket(SVector{2, ComplexF64}(1, 0))    # |↑⟩
const k_down = Ket(SVector{2, ComplexF64}(0, 1))    # |↓⟩

# --- Superposition States (X-basis / Cat-like states) ---
# |+⟩ = (|↑⟩ + |↓⟩) / √2
const k_plus  = Ket(SVector{2, ComplexF64}(1/√2, 1/√2))
# |-⟩ = (|↑⟩ - |↓⟩) / √2
const k_minus = Ket(SVector{2, ComplexF64}(1/√2, -1/√2))

# --- Y-basis States ---
# |R⟩ = (|↑⟩ + i|↓⟩) / √2
const k_right = Ket(SVector{2, ComplexF64}(1/√2, 1im/√2))
# |L⟩ = (|↑⟩ - i|↓⟩) / √2
const k_left  = Ket(SVector{2, ComplexF64}(1/√2, -1im/√2))

# 対応する Bra も定義しておくと便利
const b_up    = k_up'
const b_down  = k_down'
const b_plus  = k_plus'
const b_minus = k_minus'