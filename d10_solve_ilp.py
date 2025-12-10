#!/usr/bin/env python3
"""
Solves an Integer Linear Programming problem:
  Minimize: sum(x)
  Subject to: A @ x == target
  Bounds: x >= 0, x integer

Input via stdin: JSON with keys "A" (2D array) and "target" (1D array)
Output: JSON with key "result" (sum of x) or "error"
"""

import json
import sys
import signal
import numpy as np

def timeout_handler(signum, frame):
    raise TimeoutError("Solver timed out")

def solve(A, target):
    from scipy.optimize import milp, LinearConstraint, Bounds
    
    A = np.array(A, dtype=float)
    target = np.array(target, dtype=float)
    
    n_buttons = A.shape[1]
    
    # Objective: minimize sum(x) = [1, 1, 1, ...] @ x
    c = np.ones(n_buttons)
    
    # Equality constraint: A @ x == target
    constraints = LinearConstraint(A, target, target)
    
    # Bounds: x >= 0
    # Upper bound: no button needs to be pressed more than max(target)
    max_target = max(target) if len(target) > 0 else 1000
    bounds = Bounds(lb=0, ub=max_target)
    
    # All variables must be integers
    integrality = np.ones(n_buttons, dtype=int)
    
    # Set solver options for faster convergence
    options = {
        'time_limit': 5.0,  # 5 second timeout
        'mip_rel_gap': 0.0,  # We want exact solution
    }
    
    result = milp(c, constraints=constraints, bounds=bounds, 
                  integrality=integrality, options=options)
    
    if result.success:
        return int(round(result.fun))
    else:
        return None

if __name__ == "__main__":
    # Set a 10 second timeout for the entire script
    signal.signal(signal.SIGALRM, timeout_handler)
    signal.alarm(10)
    
    try:
        data = json.load(sys.stdin)
        result = solve(data["A"], data["target"])
        if result is not None:
            print(json.dumps({"result": result}))
        else:
            print(json.dumps({"error": "No solution found"}))
    except TimeoutError:
        print(json.dumps({"error": "Timeout"}))
    except Exception as e:
        print(json.dumps({"error": str(e)}))
    finally:
        signal.alarm(0)
